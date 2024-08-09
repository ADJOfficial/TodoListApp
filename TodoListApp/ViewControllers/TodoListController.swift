//
//  TodoListController.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 03/07/2024.
//


import UIKit
import Firebase
import FirebaseStorage

class TodoListController: UIViewController {

    private let backgroundImageView = ImageView()
    private var loader = Loader()
    private let screenTitle = Label(text: "Work List",textFont: .bold())
    private let searchFieldView = View()
    private let searchTextField = SearchTextField()
    private let tableView = TableView()
    private let addButton = SystemImageButton(image: .systemName(), size: UIImage.SymbolConfiguration(pointSize: 40), tintColor: .black)
    private let logout = Button(backgroungColor: .clear, cornerRadius: 0, setTitle: "Logout?", setTitleColor: .blue)
   
    private let db = Firestore.firestore()
    private var tasks: [WorkList] = []
    private var filteredTask: [WorkList] = []
    private var isSearching = false
    private let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        populateTasks()
        addTargets()
        configureTableView()
        searchTextField.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        populateTasks()
        loader.startAnimating()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(loader)
        view.addSubview(screenTitle)
        view.addSubview(searchFieldView)
        searchFieldView.addSubview(searchTextField)
        view.addSubview(tableView)
        view.addSubview(logout)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            searchFieldView.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 20),
            searchFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchFieldView.heightAnchor.constraint(equalToConstant: 50),
            
            searchTextField.topAnchor.constraint(equalTo: searchFieldView.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: searchFieldView.bottomAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: searchFieldView.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: searchFieldView.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: searchFieldView.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            logout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            logout.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    private func addTargets() {
        logout.addTarget(self, action: #selector(islogoutButtontapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(searchTextDidChanged), for: .editingChanged)
    }
    private func populateTasks() {
        guard let currentUser = Auth.auth().currentUser?.uid else {
            return
        }
        let collection = db.collection("users").document(currentUser).collection("work")
        collection.order(by: "taskTimeStamp", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                print("Failed to fetch tasks: \(error.localizedDescription)")
            } else {
                guard let snapshot = snapshot else {
                    print("Snapshot is nil")
                    return
                }
                self.tasks = snapshot.documents.map { doc in
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
                    let status = doc.data()["taskcurrentStatus"] as? String ?? ""
                    print("Task Current Status is : \(status)")
                    let timeStamp = doc.data()["taskTimeStamp"] as? String ?? ""
                    print("Task TimeStamp is :", timeStamp)
                    self.scheduleNotification(taskTitle: taskTitle, taskDescription: taskDescription, date: date)
                    self.loader.stopAnimating()
                    return WorkList(taskTitle: taskTitle, taskDescription: taskDescription, taskDate: date, taskImage: image, documentID: documentID, taskcurrentStatus: status, taskTimeStamp: timeStamp)
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
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error Scheduling Notifications : \(error.localizedDescription)")
            }
            else {
                print("Notification Scheduled Successfully")
            }
        }
    }
    
    @objc func islogoutButtontapped() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel){_ in
            print("Cannot Logout at this moment")
        })
        self.present(alert, animated: true)
    }
    @objc func addNewItem() {
        let newItem = AddItemController()
        navigationController?.pushViewController(newItem, animated: true)
    }
    @objc func searchTextDidChanged() {
        guard let searchText = searchTextField.text, !searchText.isEmpty else {
            isSearching = false
            tableView.reloadData()
            return
        }
        isSearching = true
        filteredTask = tasks.filter { $0.taskTitle.lowercased().contains(searchText.lowercased())}
        tableView.reloadData()
    }
}

extension TodoListController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         if let searchText = searchTextField.text, !searchText.isEmpty {
//             return tasks.filter { $0.taskTitle.lowercased().contains(searchText.lowercased()) || $0.taskDescription.lowercased().contains(searchText.lowercased()) }.count
//         }
         return isSearching ? filteredTask.count : tasks.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableViewCell
         let task = isSearching ? filteredTask[indexPath.row] : tasks[indexPath.row]
         cell.taskTitle.text = task.taskTitle
         cell.taskDescription.text = task.taskDescription
         cell.taskDate.text = task.taskDate
         let storageRef = Storage.storage().reference()
         let imageRef = storageRef.child(task.taskImage)
         imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
             if let error = error {
                 print("Error While Downloading Image \(error.localizedDescription)")
                 return
             }
             if let imageData = data {
                 DispatchQueue.main.async {
                     cell.taskImage.image = UIImage(data: imageData)
                 }
             }
         }
         let documentID = task.documentID
         let status = task.taskcurrentStatus
         let taskTimeStamp = task.taskTimeStamp
         if status == "Completed" {
             cell.cellView.backgroundColor = .systemGreen.withAlphaComponent(0.5)
         } else {
             cell.cellView.backgroundColor = .systemGray5.withAlphaComponent(0.5)
         }
         cell.didTapEditButton = {
             let taskDate = self.changeDateTimeFormate(dateString: task.taskDate)
             let editController = EditViewController(title: cell.taskTitle.text ?? "", description: cell.taskDescription.text ?? "", date: taskDate, image: cell.taskImage.image, documentID: documentID, taskTimeStamp: taskTimeStamp)
             self.navigationController?.pushViewController(editController, animated: true)
         }
         cell.didDetailsIconTapped = {
             let detailsController = WorkListDetailsViewController(title: cell.taskTitle.text ?? "", description: cell.taskDescription.text ?? "", image: cell.taskImage.image, date: cell.taskDate.text ?? "", status: status, documentID: documentID)
             self.navigationController?.pushViewController(detailsController, animated: true)
         }
         cell.didTapDeleteButton = {
             guard let indexPath = tableView.indexPath(for: cell) else {
                 return
             }
//             if self.isSearching {
//                 self.filteredTask[indexPath.row]
//             } else {
//                 self.tasks[indexPath.row]
//             }
             print("Geoooo \(indexPath)")
             let task = self.tasks[indexPath.row]
             let documentID = task.documentID
             guard let currentUser = Auth.auth().currentUser?.uid else {
                 print("Error While Deleting")
                 return
             }
             let collection = self.db.collection("users").document(currentUser).collection("work")
             let alert = UIAlertController(title: "Delete Task", message: "Are You Sure You Want to Delete This Task: \(task.taskTitle)", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Delete", style: .destructive) {_ in
                 collection.document(documentID).delete { error in
                     if let error = error {
                         print("Error While deleting Data \(error.localizedDescription)")
                     }
                     else {
                         print("Document Deleted Successfully Have unique ID : \(documentID)")
                         if indexPath.row < self.tasks.count {
                             self.tasks.remove(at: indexPath.row)
                             tableView.deleteRows(at: [indexPath], with: .automatic)
                         }
                     }
                 }
             })
             alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {_ in
                 print("Document is not Deleted")
             })
             self.present(alert, animated: true)
         }
         return cell
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
