//
//  EditViewController.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 09/07/2024.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class EditTodoListViewController : BaseViewController {
    private let screenTitle = Label(text: "Update Task",textFont: .bold())
    private let backButton = BackButton()
    private let titleTextField = TextFieldView(returnType: .next)
    private let descriptionTextField = TextFieldView(returnType: .done)
    private var dateTimePicker = DateTimePicker(minimumDate: nil)
    private let updateButton = Button(setTitle: "Update Work")
    private let selectImageText = Label(text: "Tap on image to select New Image?", textFont: .bold(ofSize: 15))
    private let imagePickerView = ImagePickerView()
    
    private let imagePicker = UIImagePickerController()
    private var titleTextFieldViewCenterContraints: NSLayoutConstraint?
    private var db = Firestore.firestore()
    private var taskTitle: String
    private var taskDescription: String
    private var taskDate: Date
    private var taskImage: UIImage?
    private var documentId: String
    private var taskTimeStamp: String
    
    init(title: String, description: String, date: Date = Date(), image: UIImage? = nil, documentID: String, taskTimeStamp: String) {
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
        addTargets()
        addObserver()
        titleTextField.textField.delegate = self
        descriptionTextField.textField.delegate = self
        self.titleTextField.textField.text = taskTitle
        self.descriptionTextField.textField.text = taskDescription
        self.dateTimePicker.date = taskDate
        if let fetchImage = taskImage {
            imagePickerView.image = fetchImage
        }
        updateButton.alpha = 0.5
        updateButton.isUserInteractionEnabled = false
        imagePickerView.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(screenTitle)
        view.addSubview(backButton)
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(dateTimePicker)
        view.addSubview(updateButton)
        view.addSubview(selectImageText)
        view.addSubview(imagePickerView)
        NSLayoutConstraint.activate([
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5.autoSized),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5.widthRatio),
            
            titleTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            descriptionTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 25.autoSized),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            dateTimePicker.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20.autoSized),
            dateTimePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            selectImageText.topAnchor.constraint(equalTo: dateTimePicker.bottomAnchor, constant: 20.autoSized),
            selectImageText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imagePickerView.heightAnchor.constraint(equalToConstant: 150.autoSized),
            imagePickerView.topAnchor.constraint(equalTo: selectImageText.bottomAnchor, constant: 15.autoSized),
            imagePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            imagePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            updateButton.heightAnchor.constraint(equalToConstant: 50.autoSized),
            updateButton.topAnchor.constraint(equalTo: imagePickerView.bottomAnchor, constant: 10.autoSized),
            updateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            updateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
        ])
        titleTextFieldViewCenterContraints = titleTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25.autoSized)
        titleTextFieldViewCenterContraints?.isActive = true
    }
    private func addTargets() {
        updateButton.addTarget(self, action: #selector(updateTask), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let tappedImageView = UITapGestureRecognizer(target: self, action: #selector(didTappedImageView))
        imagePickerView.addGestureRecognizer(tappedImageView)
        titleTextField.textField.addTarget(self, action: #selector(didTextFieldEditingChanged), for: .editingChanged)
        descriptionTextField.textField.addTarget(self, action: #selector(didTextFieldEditingChanged), for: .editingChanged)
        dateTimePicker.addTarget(self, action: #selector(didTextFieldEditingChanged), for: .valueChanged)
    }
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardisShowing = view.frame.origin.y == 0
        if keyboardisShowing {
            UIView.animate(withDuration: 0.3) {
                self.titleTextFieldViewCenterContraints?.constant = -300
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHidden(notification: Notification) {
        let keyboardIsHidden = view.frame.origin.y == 0
        if keyboardIsHidden {
            UIView.animate(withDuration: 0.3) {
                self.titleTextFieldViewCenterContraints?.constant = -25
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func didTextFieldEditingChanged() {
        let isEditingChanged = titleTextField.textField.text?.trimmingCharacters(in: .whitespaces) != taskTitle || descriptionTextField.textField.text?.trimmingCharacters(in: .whitespaces) != taskDescription || dateTimePicker.date > taskDate || imagePickerView.image != taskImage
        updateButton.alpha = isEditingChanged ? 1.0 : 0.5
        updateButton.isUserInteractionEnabled = isEditingChanged
    }
    @objc func changeDateTimeFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy h:mm a\nEEEE"
        let dateString = dateFormatter.string(from: dateTimePicker.date)
        return dateString
    }
    @objc func updateTask() {
        let timeStamp = Timestamp()
        guard let currentUser = Auth.auth().currentUser?.uid else {
            print("Error While Updating")
            return
        }
        let updateTask = db.collection("users").document(currentUser).collection("work")
        if let image = imagePickerView.image {
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
            let taskData = ["taskTitle": titleTextField.textField.text ?? "", "taskDescription": descriptionTextField.textField.text ?? "", "taskDate": changeDateTimeFormat(),"taskImage": path, "taskEdited": true, "taskcurrentStatus": "Pending", "taskTimeStamp": timeStamp] as [String : Any]
            updateTask.document(documentId).setData(taskData) { error in
                if let error = error {
                    print("Task Not Updated: \(error.localizedDescription)")
                    self.popupAlert(title: "Operation Failed", message: error.localizedDescription, actionTitles: ["Try Again"], actionStyles: [.cancel], actions: [{ _ in
                        print("Try Again")
                    }])
                } else {
                    print("Data Updated successfully")
                    self.popupAlert(title: "Successful", message: "Well done! Your work updated successfully", actionTitles: ["Go To List"], actionStyles: [.default], actions: [{ _ in
                        self.navigationController?.popViewController(animated: true)
                    }])
                }
            }
        } else {
            let taskData = ["taskTitle": titleTextField.textField.text ?? "", "taskDescription": descriptionTextField.textField.text ?? "", "taskDate": changeDateTimeFormat(),"taskImage": nil ?? "", "taskEdited": true, "taskcurrentStatus": "Pending", "taskTimeStamp": timeStamp] as [String : Any]
            updateTask.document(documentId).setData(taskData) { error in
                if let error = error {
                    print("Task Not Updated: \(error.localizedDescription)")
                    self.popupAlert(title: "Operation Failed", message: error.localizedDescription, actionTitles: ["Try Again"], actionStyles: [.cancel], actions: [{ _ in
                        print("Try Again")
                    }])
                } else {
                    print("Data Updated successfully")
                    self.popupAlert(title: "Successful", message: "Well done! Your work updated successfully", actionTitles: ["Go To List"], actionStyles: [.default], actions: [{ _ in
                        self.navigationController?.popViewController(animated: true)
                    }])
                }
            }
        }
    }
    @objc func didTappedImageView() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        popupAlert(title: "Choose Image Source", message: nil, style: .actionSheet, actionTitles: ["Camera","Photo Library","Cancel"], actionStyles: [.default,.default,.destructive], actions: [{ _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("Camera is not available")
            }
        }, { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }, { _ in
            print("Operation Cancelled")
        }])
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension EditTodoListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            imagePickerView.image = selectedImage
            if taskImage != selectedImage {
                didTextFieldEditingChanged()
            }
        } else if let selectedImage = info[.originalImage] as? UIImage {
            imagePickerView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField.textField {
            descriptionTextField.textField.becomeFirstResponder()
        }else {
            descriptionTextField.textField.resignFirstResponder()
        }
        return true
    }
}
