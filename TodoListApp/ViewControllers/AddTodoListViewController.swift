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

class AddTodoListViewController: BaseViewController {
    private let backButton = BackButton()
    private let screenTitle = Label(text: "New Work", textFont: .bold())
    private let titleTextField = TextFieldView(placeholder: "Enter task title", returnType: .next)
    private let descriptionTextField = TextFieldView(placeholder: "Enter task description", returnType: .done)
    private let dateTimePicker = DateTimePicker()
    private let uploadImageLabel = Label(text: "Upload an Image ?", textFont: .bold(ofSize: 20))
    private let imagePickerView = ImagePickerView(backgroundColor: .clear)
    private let createButton = Button(setTitle: "Create")
    
    private var db = Firestore.firestore()
    private let imagePicker = UIImagePickerController()
    private var titleTextFieldCenterYContraints: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        addObserver()
        createButton.alpha = 0.5
        createButton.isUserInteractionEnabled = false
        titleTextField.textField.delegate = self
        descriptionTextField.textField.delegate = self
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
        view.addSubview(uploadImageLabel)
        view.addSubview(imagePickerView)
        view.addSubview(createButton)
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
            
            dateTimePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateTimePicker.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20.autoSized),
            
            uploadImageLabel.topAnchor.constraint(equalTo: dateTimePicker.bottomAnchor, constant: 15.autoSized),
            uploadImageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imagePickerView.heightAnchor.constraint(equalToConstant: 150.autoSized),
            imagePickerView.topAnchor.constraint(equalTo: uploadImageLabel.bottomAnchor, constant: 20.autoSized),
            imagePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            imagePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            createButton.heightAnchor.constraint(equalToConstant: 50.autoSized),
            createButton.topAnchor.constraint(equalTo: imagePickerView.bottomAnchor, constant: 10.autoSized),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
        ])
        titleTextFieldCenterYContraints = titleTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25.autoSized)
        titleTextFieldCenterYContraints?.isActive = true
    }
    private func addTargets() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        titleTextField.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        descriptionTextField.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        dateTimePicker.addTarget(self, action: #selector(didTextFieldChanged), for: .valueChanged)
        let tappedLabel = UITapGestureRecognizer(target: self, action: #selector(didTappedUploadLabel))
        uploadImageLabel.addGestureRecognizer(tappedLabel)
        uploadImageLabel.isUserInteractionEnabled = true
    }
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardisShowing = view.frame.origin.y == 0
        if keyboardisShowing {
            UIView.animate(withDuration: 0.3) {
                self.titleTextFieldCenterYContraints?.constant = -300
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHidden(notification: Notification) {
        let keyboardIsHidden = view.frame.origin.y == 0
        if keyboardIsHidden {
            UIView.animate(withDuration: 0.3) {
                self.titleTextFieldCenterYContraints?.constant = -25
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func didTextFieldChanged() {
        let currentDateTime = Date()
        let isChanged = titleTextField.textField.text?.isEmpty == false && descriptionTextField.textField.text?.isEmpty == false && dateTimePicker.date > currentDateTime
        createButton.isUserInteractionEnabled = isChanged
        createButton.alpha = isChanged ? 1.0 : 0.5
    }
    @objc func didTappedUploadLabel() {
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
    @objc func changeDateTimeFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy h:mm a\nEEEE"
        let dateString = dateFormatter.string(from: dateTimePicker.date)
        return dateString
    }
    @objc func addItem() {
        guard let currentUser = Auth.auth().currentUser?.uid else{
            return
        }
        let timestamp = Timestamp()
        let collection = db.collection("users").document(currentUser).collection("work")
        if let image = imagePickerView.image {
            let storageRef = Storage.storage().reference()
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                return
            }
            let path = "image/\(UUID().uuidString).jpg"
            let imageRef = storageRef.child(path)
            imageRef.putData(imageData, metadata: nil) {( _ , error) in
                if let error = error {
                    print("Error While Uploading Image\(error.localizedDescription)")
                }
            }
            collection.addDocument(data: ["taskTitle": titleTextField.textField.text ?? "", "taskDescription": descriptionTextField.textField.text ?? "", "taskDate": changeDateTimeFormat(),"taskImage": path,"taskcurrentStatus": "Pending", "taskTimeStamp": timestamp]) { error in
                if let error = error {
                    print("Task Not Added: \(error.localizedDescription)")
                    self.popupAlert(title: "Task not Saved", message: error.localizedDescription, actionTitles: ["Try Again"], actionStyles: [.cancel], actions: [{ action in
                        print("Try Again")
                    }])
                } else {
                    print("Data saved successfully")
                    self.popupAlert(title: "Successful", message: "Task Added successfully! Go back to see your work", actionTitles: ["Back To List","Create More"], actionStyles: [.destructive,.cancel], actions: [{ _ in
                        self.navigationController?.popViewController(animated: true)
                    }, { _ in
                        print("Create More")
                    }])
                }
            }
        } else {
            collection.addDocument(data: ["taskTitle": titleTextField.textField.text ?? "", "taskDescription": descriptionTextField.textField.text ?? "", "taskDate": changeDateTimeFormat(),"taskImage": nil ?? "","taskcurrentStatus": "Pending", "taskTimeStamp": timestamp]) { error in
                if let error = error {
                    print("Task Not Added: \(error.localizedDescription)")
                    self.popupAlert(title: "Task not Saved", message: error.localizedDescription, actionTitles: ["Try Again"], actionStyles: [.cancel], actions: [{ action in
                        print("Try Again")
                    }])
                } else {
                    print("Data saved successfully")
                    self.popupAlert(title: "Successful", message: "Task Added successfully! Go back to see your work", actionTitles: ["Back To List","Create More"], actionStyles: [.destructive,.cancel], actions: [{ _ in
                        self.navigationController?.popViewController(animated: true)
                    }, { _ in
                        print("Create More")
                    }])
                }
            }
        }
        DispatchQueue.main.async {
            self.titleTextField.textField.text = ""
            self.descriptionTextField.textField.text = ""
            self.imagePickerView.image = nil
        }
    }
}
extension AddTodoListViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate {
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
        if textField == titleTextField.textField {
            descriptionTextField.textField.becomeFirstResponder()
        }else {
            descriptionTextField.textField.resignFirstResponder()
        }
        return true
    }
}
