//
//  WorkListDetailsViewController.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 26/07/2024.
//

import UIKit
import Firebase
import FirebaseStorage

class WorkListDetailsViewController: UIViewController {
    
    private let backgroundView = ImageView()
    private let backButton = BackButton()
    private let statusView = View(backgroundColor: .systemPink.withAlphaComponent(0.3))
    private let currentstatus = Label(textFont: .bold(ofSize: 15))
    private let screentitle = Label(text: "Details",textFont: .bold(ofSize: 40))
    private let headingTitle = Label(text: "Title:",textFont: .bold(ofSize: 25))
    private let workTitle = Label(text: "",textFont: .medium(ofSize: 23))
    private let headingDate = Label(text: "Work Date:",textFont: .bold(ofSize: 25))
    private let workDate = Label(text: "",textFont: .medium(ofSize: 23))
    private let headingDescription = Label(text: "Description:",textFont: .bold(ofSize: 25))
    private var workDescription = Label(text: "",textFont: .medium(ofSize: 23))
    private let imageView = ImagePickerView()
    private let finishButton = Button(backgroungColor: .systemGreen.withAlphaComponent(0.8),setTitle: "Done", setTitleColor: .white)
    
    private var db = Firestore.firestore()
    private var taskName: String
    private var taskDescription: String
    private var taskImage: UIImage?
    private var taskDate: String
    private var taskStatus: String
    private var taskDocumentID: String
    
    init(title: String, description: String, image: UIImage?, date: String, status: String, documentID: String) {
        self.taskName = title
        self.taskDescription = description
        self.taskImage = image
        self.taskDate = date
        self.taskStatus = status
        self.taskDocumentID = documentID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
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
    
    private func setUpViews() {
        view.addSubview(backgroundView)
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
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            screentitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screentitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: screentitle.bottomAnchor, constant: 10),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
             
            statusView.widthAnchor.constraint(equalToConstant: 150),
            statusView.heightAnchor.constraint(equalToConstant: 50),
            statusView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            statusView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            currentstatus.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            currentstatus.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),

            headingTitle.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 20),
            headingTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            workTitle.topAnchor.constraint(equalTo: headingTitle.bottomAnchor, constant: 10),
            workTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            imageView.widthAnchor.constraint(equalToConstant: 350),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: workTitle.bottomAnchor, constant: 20),
            
            headingDescription.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            headingDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            workDescription.topAnchor.constraint(equalTo: headingDescription.bottomAnchor, constant: 10),
            workDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            headingDate.topAnchor.constraint(equalTo: workDescription.bottomAnchor, constant: 15),
            headingDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            workDate.topAnchor.constraint(equalTo: headingDate.bottomAnchor, constant: 10),
            workDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            finishButton.widthAnchor.constraint(equalToConstant: 150),
            finishButton.heightAnchor.constraint(equalToConstant: 50),
            finishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    private func addTargets() {
        backButton.addTarget(self, action: #selector(didDetailsButtonTapped), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(changeStatus), for: .touchUpInside)
    }
    private func didTaskCompleted() {
        if taskStatus == "Completed" {
            finishButton.alpha = 0.5
            finishButton.backgroundColor = .black
            finishButton.isUserInteractionEnabled = false
        } else {
            finishButton.alpha = 1.0
            finishButton.isUserInteractionEnabled = true
        }
    }
    private func didTaskRemaining () {
        if taskStatus == "Pending" {
            statusView.backgroundColor = .systemYellow.withAlphaComponent(0.5)
        } else {
            statusView.backgroundColor = .systemPink.withAlphaComponent(0.5)
        }
    }
    
    @objc func changeStatus() {
        let timeStamp = Timestamp()
        guard let currentUser = Auth.auth().currentUser?.uid else {
            print("Error While Updating")
            return
        }
        let updateTask = db.collection("users").document(currentUser).collection("work")
        let storageRef = Storage.storage().reference()
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.8) else {
            return
        }
        let path = "image/\(UUID().uuidString).jpg"
        let imageRef = storageRef.child(path)
        imageRef.putData(imageData, metadata: nil) {(metadate , error) in
            if let error = error {
                print("Error While Uploading Image\(error.localizedDescription)")
            }
        }
        let taskData = ["task_Title": taskName, "task_Description": taskDescription, "task_Date": taskDate,"task_Image": path,"task_currentStatus": "Completed", "task_TimeStamp": timeStamp] as [String : Any]
        updateTask.document(taskDocumentID).setData(taskData) { error in
            if let error = error {
                print("Task Not Updated: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Task Update Unsuccessful", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("Status Updated Successful")
                let alert = UIAlertController(title: "Congratulations", message: "You have completed your work.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @objc func didDetailsButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
