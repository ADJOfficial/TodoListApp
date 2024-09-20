//
//  WorkListDetailsViewController.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 26/07/2024.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class TodoListDetailsViewController: BaseViewController { 
    
    private let screentitle = Label(text: "Details",textFont: .bold())
    private let backButton = BackButton()
    private let statusView = View(backgroundColor: .systemPink.withAlphaComponent(0.3))
    private let currentstatus = Label(text: "", textFont: .bold(ofSize: 15))
    private let headingTitle = Label(text: "Title:",textFont: .bold(ofSize: 25))
    private let workTitle = Label(text: "",textFont: .medium(ofSize: 23))
    private let headingDate = Label(text: "Work Date:",textFont: .bold(ofSize: 25))
    private let workDate = Label(text: "",textFont: .medium(ofSize: 23))
    private let headingDescription = Label(text: "Description:",textFont: .bold(ofSize: 25))
    private var workDescription = Label(text: "",textFont: .medium(ofSize: 23))
    private let imageView = ImagePickerView()
    private let finishButton = Button(backgroungColor: .systemGreen.withAlphaComponent(0.8), setTitle: "Done", setTitleColor: .white)
    
    private var db = Firestore.firestore()
    private var taskName: String
    private var taskDescription: String
    private var taskImage: UIImage?
    private var taskDate: String
    private var taskEdited: String
    private var taskStatus: String
    private var taskDocumentID: String
    
    init(title: String = "", description: String = "", image: UIImage? = nil, date: String = "", edited: String = "", status: String = "", documentID: String = "") {
        self.taskName = title
        self.taskDescription = description
        self.taskImage = image
        self.taskDate = date
        self.taskEdited = edited
        self.taskStatus = status
        self.taskDocumentID = documentID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        didTaskRemaining()
        didTaskCompleted()
        self.workTitle.text = taskName
        self.workDate.text = taskDate
        if let fetchImage = taskImage {
            imageView.image = fetchImage
        }
        self.workDescription.text = taskDescription
        self.currentstatus.text = taskStatus
    }
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(screentitle)
        view.addSubview(backButton)
        view.addSubview(statusView)
        statusView.addSubview(currentstatus)
        view.addSubview(headingTitle)
        view.addSubview(workTitle)
        view.addSubview(imageView)
        view.addSubview(headingDescription)
        view.addSubview(workDescription)
        view.addSubview(headingDate)
        view.addSubview(workDate)
        view.addSubview(finishButton)
        NSLayoutConstraint.activate([
            screentitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screentitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5.autoSized),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5.widthRatio),
            
            statusView.widthAnchor.constraint(equalToConstant: 150.widthRatio),
            statusView.heightAnchor.constraint(equalToConstant: 50.autoSized),
            statusView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20.autoSized),
            statusView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            currentstatus.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            currentstatus.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
            
            headingTitle.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 20.autoSized),
            headingTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.widthRatio),
            
            workTitle.topAnchor.constraint(equalTo: headingTitle.bottomAnchor),
            workTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            
            imageView.widthAnchor.constraint(equalToConstant: 350.widthRatio),
            imageView.heightAnchor.constraint(equalToConstant: 250.autoSized),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: workTitle.bottomAnchor, constant: 20.autoSized),
            
            headingDescription.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20.autoSized),
            headingDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.widthRatio),
            
            workDescription.topAnchor.constraint(equalTo: headingDescription.bottomAnchor),
            workDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            workDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5.widthRatio),
            
            headingDate.topAnchor.constraint(equalTo: workDescription.bottomAnchor, constant: 15.autoSized),
            headingDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.widthRatio),
            
            workDate.topAnchor.constraint(equalTo: headingDate.bottomAnchor),
            workDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            
            finishButton.heightAnchor.constraint(equalToConstant: 50.autoSized),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            finishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    private func addTargets() {
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(changeStatus), for: .touchUpInside)
    }
    private func didTaskCompleted() {
        if taskStatus == "Completed" {
            finishButton.alpha = 0.5
            finishButton.backgroundColor = .black
            finishButton.isUserInteractionEnabled = false
        } else if taskStatus == "Missed" {
            finishButton.alpha = 0.5
            finishButton.backgroundColor = .black
            finishButton.isUserInteractionEnabled = false
        } else {
            finishButton.alpha = 1.0
            finishButton.backgroundColor = .black
            finishButton.isUserInteractionEnabled = true
        }
    }
    private func didTaskRemaining() {
        if taskStatus == "Pending" {
            currentstatus.textColor = .systemYellow
            statusView.backgroundColor = .black.withAlphaComponent(0.8)
        } else if taskStatus == "Missed" {
            currentstatus.textColor = .systemRed
            statusView.backgroundColor = .black.withAlphaComponent(0.8)
        } else {
            currentstatus.textColor = .systemGreen
            statusView.backgroundColor = .black.withAlphaComponent(0.8)
        }
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
    @objc func changeStatus() {
        let currentDate = Date()
        let timeStamp = Timestamp(date: currentDate)
        var taskCurrentStatus = "Completed"
        
        if currentDate > changeDateTimeFormate(dateString: taskDate) {
            taskCurrentStatus = "Missed"
        }
        guard let currentUser = Auth.auth().currentUser?.uid else {
            print("Error While Updating")
            return
        }
        let updateTask = db.collection("users").document(currentUser).collection("work")
        if let image = imageView.image {
            let storageRef = Storage.storage().reference()
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                return
            }
            let path = "image/\(UUID().uuidString).jpg"
            let imageRef = storageRef.child(path)
            imageRef.putData(imageData, metadata: nil) {(metadate , error) in
                if let error = error {
                    print("Error While Uploading Image\(error.localizedDescription)")
                }
            }
            let taskData = ["taskTitle": taskName, "taskDescription": taskDescription, "taskDate": taskDate,"taskImage": path, "taskEdited": !taskEdited.isEmpty, "taskcurrentStatus": taskCurrentStatus, "taskTimeStamp": timeStamp] as [String : Any]
            updateTask.document(taskDocumentID).setData(taskData) { error in
                if let error = error {
                    print("Task Not Updated: \(error.localizedDescription)")
                    self.popupAlert(title: "Try Again", message: error.localizedDescription, actionTitles: ["Try Again"], actionStyles: [.cancel], actions:[{ _ in
                        print("Try Again")
                    }])
                } else {
                    print("Status Updated Successful")
                    if currentDate < self.changeDateTimeFormate(dateString: self.taskDate) {
                        self.popupAlert(title: "Congratulations", message: "Well Done! You have completed your work before time", actionTitles: ["Go To List"], actionStyles: [.default], actions:[{ _ in
                            self.navigationController?.popViewController(animated: true)
                        }])
                    } else {
                        self.popupAlert(title: "Warning !", message: "Bad Work! You have completed your work after defined time", actionTitles: ["Go To List"], actionStyles: [.default], actions:[{ _ in
                            self.navigationController?.popViewController(animated: true)
                        }])
                    }
                }
            }
        } else {
            let taskData = ["taskTitle": taskName, "taskDescription": taskDescription, "taskDate": taskDate,"taskImage": nil ?? "", "taskEdited": !taskEdited.isEmpty, "taskcurrentStatus": taskCurrentStatus, "taskTimeStamp": timeStamp] as [String : Any]
            updateTask.document(taskDocumentID).setData(taskData) { error in
                if let error = error {
                    print("Task Not Updated: \(error.localizedDescription)")
                    self.popupAlert(title: "Try Again", message: error.localizedDescription, actionTitles: ["Try Again"], actionStyles: [.cancel], actions:[{ _ in
                        print("Try Again")
                    }])
                } else {
                    print("Status Updated Successful")
                    if currentDate < self.changeDateTimeFormate(dateString: self.taskDate) {
                        self.popupAlert(title: "Congratulations", message: "Well Done! You have completed your work before time", actionTitles: ["Go To List"], actionStyles: [.default], actions:[{ _ in
                            self.navigationController?.popViewController(animated: true)
                        }])
                    } else {
                        self.popupAlert(title: "Warning !", message: "Bad Work! You have completed your work after defined time", actionTitles: ["Go To List"], actionStyles: [.default], actions:[{ _ in
                            self.navigationController?.popViewController(animated: true)
                        }])
                    }
                }
            }
        }
    }
    @objc func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
