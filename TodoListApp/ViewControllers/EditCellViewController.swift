//
//  EditViewController.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 09/07/2024.
//

import UIKit
import Firebase
import FirebaseStorage

class EditViewController: UIViewController {
    
    private let backgroundImageView = ImageView()
    private let screenTitle = Label(text: "Update Task",textFont: .bold())
    private let backButton = BackButton()
    private let titleView = View()
    private let titleTextField = TextField(returnType: .next)
    private let descriptionView = View()
    private let descriptionTextField = TextField(returnType: .done)
    private let dateTimePicker = DateTimePicker()
    private let updateButton = Button(setTitle: "Update")
    private let selectImageText = Label(text: "Tap on view to select New Image?", textFont: .bold(ofSize: 10))
    private let imagePickerView = ImagePickerView()
    
    private var db = Firestore.firestore()
    private let imagePicker = UIImagePickerController()
    private var taskTitle: String
    private var taskDescription: String
    private var taskDate: Date
    private var taskImage: UIImage?
    private var documentId: String
    private var taskTimeStamp: String
    
    init(title: String, description: String, date: Date, image: UIImage?, documentID: String, taskTimeStamp: String) {
        self.taskTitle = title
        self.taskDescription = description
        self.taskDate = date
        self.taskImage = image
        self.documentId = documentID
        self.taskTimeStamp = taskTimeStamp
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addTargets()
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        self.titleTextField.text = taskTitle
        self.descriptionTextField.text = taskDescription
        self.dateTimePicker.date = taskDate
        if let fetchImage = taskImage {
            imagePickerView.image = fetchImage
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(screenTitle)
        view.addSubview(backButton)
        view.addSubview(titleView)
        titleView.addSubview(titleTextField)
        view.addSubview(descriptionView)
        descriptionView.addSubview(descriptionTextField)
        view.addSubview(dateTimePicker)
        view.addSubview(updateButton)
        view.addSubview(selectImageText)
        view.addSubview(imagePickerView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleView.heightAnchor.constraint(equalToConstant: 50),
            
            titleTextField.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -20),
            titleTextField.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleTextField.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            
            descriptionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionView.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionTextField.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -20),
            descriptionTextField.topAnchor.constraint(equalTo: descriptionView.topAnchor),
            descriptionTextField.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor),
            
            dateTimePicker.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20),
            dateTimePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            updateButton.widthAnchor.constraint(equalToConstant: 150),
            updateButton.heightAnchor.constraint(equalToConstant: 50),
            updateButton.topAnchor.constraint(equalTo: dateTimePicker.bottomAnchor, constant: 25),
            updateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            selectImageText.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 10),
            selectImageText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            imagePickerView.widthAnchor.constraint(equalToConstant: 200),
            imagePickerView.heightAnchor.constraint(equalToConstant: 150),
            imagePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imagePickerView.topAnchor.constraint(equalTo: selectImageText.bottomAnchor, constant: 5),
        ])
    }
    private func addTargets() {
        updateButton.addTarget(self, action: #selector(updateTask), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let tappedImageView = UITapGestureRecognizer(target: self, action: #selector(didTappedImageView))
        imagePickerView.addGestureRecognizer(tappedImageView)
        imagePickerView.isUserInteractionEnabled = true
    }
    
    @objc func updateTask() {
        let timeStamp = Timestamp()
        guard let currentUser = Auth.auth().currentUser?.uid else {
            print("Error While Updating")
            return
        }
        let updateTask = db.collection("users").document(currentUser).collection("work")
        let storageRef = Storage.storage().reference()
        guard let imageData = imagePickerView.image?.jpegData(compressionQuality: 0.8) else {
            return
        }
        let path = "image/\(UUID().uuidString).jpg"
        let imageRef = storageRef.child(path)
        imageRef.putData(imageData, metadata: nil) {(metadate , error) in
            if let error = error {
                print("Error While Uploading Image\(error.localizedDescription)")
            }
        }
        let taskData = ["taskTitle": titleTextField.text ?? "", "taskDescription": descriptionTextField.text ?? "", "taskDate": changeDateFormate(),"taskImage": path,"taskcurrentStatus": "Pending", "taskTimeStamp": timeStamp] as [String : Any]
        updateTask.document(documentId).setData(taskData) { error in
            if let error = error {
                print("Task Not Updated: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Task Update Unsuccessful", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("Data Updated successfully")
                let alert = UIAlertController(title: "Update Successful", message: "Tap on ok to go back to Work List.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
            }
            DispatchQueue.main.async {
                self.titleTextField.text = ""
                self.descriptionTextField.text = ""
            }
        }
    }
    @objc func changeDateFormate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy h:mm a\nEEEE"
        let dateString = dateFormatter.string(from: dateTimePicker.date)
        return dateString
    }
    @objc func didTappedImageView() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let actionSheet = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("Camera is not available")
            }
        })
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default) {_ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            imagePickerView.image = selectedImage
        } else if let selectedImage = info[.originalImage] as? UIImage {
            imagePickerView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            descriptionTextField.becomeFirstResponder()
        }else {
            descriptionTextField.resignFirstResponder()
        }
        return true
    }
}
