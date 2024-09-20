//
//  TodoListController.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 03/07/2024.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class TodoListViewController: BaseViewController {
    private var loader = Loader()
    private let screenTitle = Label(text: "Work List",textFont: .bold())
    private let searchBar = SearchBar()
    private let tableView = TableView()
    private let addButton = SystemImageButton(image: UIImage(systemName: "plus.circle.fill"), size: UIImage.SymbolConfiguration(pointSize: 40), tintColor: .black)
    private let logoutLabel = Label(text: "Logout?", textFont: .bold(ofSize: 18))
    
    private let firestoreDB = Firestore.firestore()
    private var todoList: [TodoListModel] = []
    private var filteredTodoList: [TodoListModel] = []
    private var isSearching = false
    private let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        configureTableView()
        searchBar.delegate = self
        logoutLabel.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateTasks()
        loader.startAnimating()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(loader)
        view.addSubview(screenTitle)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(logoutLabel)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            searchBar.heightAnchor.constraint(equalToConstant: 50.autoSized),
            searchBar.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 10.autoSized),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.widthRatio),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.widthRatio),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10.autoSized),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20.autoSized),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            logoutLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.autoSized),
            logoutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio)
        ])
    }
    private func addTargets() {
        addButton.addTarget(self, action: #selector(addTodoItem), for: .touchUpInside)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didlogoutButtontapped))
        logoutLabel.addGestureRecognizer(gesture)
    }
    private func populateTasks() {
        guard let currentUser = Auth.auth().currentUser?.uid else {
            return
        }
        let collection = firestoreDB.collection("users").document(currentUser).collection("work")
        collection.order(by: "taskTimeStamp", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                print("Failed to fetch tasks: \(error.localizedDescription)")
            } else {
                guard let snapshot = snapshot, !snapshot.isEmpty else {
                    self.popupAlert(title: "You Have No Record", message: "Hurry Up! it's time to do some new work", actionTitles: ["Logout","Let's Create"], actionStyles: [.destructive, .default], actions: [{ _ in
                        let addController = AddTodoListViewController()
                        self.navigationController?.pushViewController(addController, animated: true)
                    }, { _ in
                        self.navigationController?.popViewController(animated: true)
                    }])
                    self.loader.stopAnimating()
                    return
                }
                self.todoList = snapshot.documents.map { doc in
                    let taskTitle = doc.data()["taskTitle"] as? String ?? ""
                    print("Title of Task is : ", taskTitle)
                    let taskDescription = doc.data()["taskDescription"] as? String ?? ""
                    print("Description of Task is : ", taskDescription)
                    let date = doc.data()["taskDate"] as? String ?? ""
                    print("Date is : ", date)
                    let documentID = doc.documentID
                    print("Document ID is :", documentID)
                    let image = doc.data()["taskImage"] as? String ?? ""
                    print("Image is : ", image)
                    let edited = doc.data()["taskEdited"] as? Bool ?? false
                    print("Edited is ", edited)
                    let status = doc.data()["taskcurrentStatus"] as? String ?? ""
                    print("Task Current Status is : \(status)")
                    let timeStamp = doc.data()["taskTimeStamp"] as? String ?? ""
                    print("Task TimeStamp is :", timeStamp)
                    self.scheduleNotification(taskTitle: taskTitle, taskDescription: taskDescription, date: date)
                    self.loader.stopAnimating()
                    return TodoListModel(taskTitle: taskTitle, taskDescription: taskDescription, taskDate: date, taskImage: image, documentID: documentID, taskEdited: edited, taskcurrentStatus: status, taskTimeStamp: timeStamp)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
    }
    private func changeDateTimeFormate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy h:mm a\nEEEE"
        if let formattedDate = dateFormatter.date(from: dateString){
            return formattedDate
        }
        else {
            return Date()
        }
    }
    private func scheduleNotification(taskTitle: String, taskDescription: String, date: String) {
        let content = UNMutableNotificationContent()
        content.title = taskTitle
        content.sound = .default
        content.body = taskDescription
        let targetDate = changeDateTimeFormate(dateString: date)
        let timeInterval = [-4, -2, -1]
        for interval in timeInterval {
            let notificationDate = Calendar.current.date(byAdding: .minute, value: interval, to: targetDate) ?? targetDate
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate), repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error Scheduling Notifications: \(error.localizedDescription)")
                } else {
                    print("Notification Scheduled Successfully")
                }
            }
        }
    }

    @objc func didlogoutButtontapped() {
        self.popupAlert(title: "Logout", message: "Are you sure you want to logout", actionTitles: ["Cancel","Logout"], actionStyles: [.default,.destructive], actions: [{ _ in
            print("Operation Cancelled")
        }, { _ in
            self.navigationController?.popViewController(animated: true)
        }])
    }
    @objc func addTodoItem() {
        let addTodoList = AddTodoListViewController()
        navigationController?.pushViewController(addTodoList, animated: true)
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return isSearching ? filteredTodoList.count : todoList.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableViewCell
         let task = isSearching ? filteredTodoList[indexPath.row] : todoList[indexPath.row]
         cell.taskTitle.text = task.taskTitle
         if task.taskEdited {
             cell.editedWork.text = "( Edited )"
         } else {
             cell.editedWork.text = ""
         }
         cell.taskDescription.text = task.taskDescription
         cell.taskDate.text = task.taskDate
         let storageRef = Storage.storage().reference()
         if !task.taskImage.isEmpty {
             let imageRef = storageRef.child(task.taskImage)
             imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                 if let error = error {
                     print("Error While Downloading Image \(error.localizedDescription)")
                     return
                 }
                 if let imageData = data, let image = UIImage(data: imageData) {
                     DispatchQueue.main.async {
                         if let currentCell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
                             currentCell.taskImage.image = image
                         }
                     }
                 }
             }
         } else {
             DispatchQueue.main.async {
                 if let currentCell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
                     currentCell.taskImage.image = nil
                 }
             }
         }
         let documentID = task.documentID
         let status = task.taskcurrentStatus
         let taskTimeStamp = task.taskTimeStamp
         if status == "Completed" {
             cell.cellView.updateGradientColors([UIColor.systemGreen.withAlphaComponent(0.5),UIColor.black])
         } else if status == "Missed"{
             cell.cellView.updateGradientColors([UIColor.systemRed.withAlphaComponent(0.5),UIColor.black])
         } else {
             cell.cellView.updateGradientColors([UIColor.systemCyan.withAlphaComponent(0.5),UIColor.black])
         } // Load all data on cell all Mean image and status 
         cell.didTapEditButton = {
             let taskDate = self.changeDateTimeFormate(dateString: task.taskDate)
             let editController = EditTodoListViewController(title: cell.taskTitle.text ?? "", description: cell.taskDescription.text ?? "", date: taskDate, image: cell.taskImage.image, documentID: documentID, taskTimeStamp: taskTimeStamp)
             self.navigationController?.pushViewController(editController, animated: true)
         }
         cell.didDetailsIconTapped = {
             let detailsController = TodoListDetailsViewController(title: cell.taskTitle.text ?? "", description: cell.taskDescription.text ?? "", image: cell.taskImage.image, date: cell.taskDate.text ?? "", edited: cell.editedWork.text ?? "", status: status, documentID: documentID)
             self.navigationController?.pushViewController(detailsController, animated: true)
         } // Make Seperate Func for every Action
         cell.didTapDeleteButton = {
             guard let indexPath = tableView.indexPath(for: cell) else {
                 return
             }
             print("Index and Task count : \(indexPath)")
             let task = self.todoList[indexPath.row]
             let documentID = task.documentID
             guard let currentUser = Auth.auth().currentUser?.uid else {
                 print("Error While Deleting")
                 return
             }
             let collection = self.firestoreDB.collection("users").document(currentUser).collection("work")
             self.popupAlert(title: "Delete Task", message: "Are You Sure You Want to Delete This Task: \(task.taskTitle)", actionTitles: ["Cancel","Delete"], actionStyles: [.default, .destructive], actions: [{ _ in
                 print("Operation cancelled task not deleted")
             }, { _ in
                 collection.document(documentID).delete { error in
                     if let error = error {
                         print("Error While deleting Data \(error.localizedDescription)")
                     }
                     else {
                         print("Document Deleted Successfully Have unique ID : \(documentID)")
                         if self.isSearching {
                             self.filteredTodoList.remove(at: indexPath.row)
                         }
                         if indexPath.row < self.todoList.count {
                             self.todoList.remove(at: indexPath.row)
                         } 
                         tableView.deleteRows(at: [indexPath], with: .automatic)
                     }
                 }
             }])
         }
         return cell
    } // Make whole Controller with max line of 120
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let search = searchBar.text, !search.isEmpty else {
            isSearching = false
            tableView.reloadData()
            return
        }
        isSearching = true
        filteredTodoList = todoList.filter { $0.taskTitle.lowercased().contains(search.lowercased()) || $0.taskDescription.lowercased().contains(search.lowercased())}
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        return
    }
}
