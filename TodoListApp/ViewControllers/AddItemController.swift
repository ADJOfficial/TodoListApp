//
//  TodoListController.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 03/07/2024.
//


import UIKit
import Firebase
import FirebaseStorage

class AddItemController: UIViewController {
    
    private let backgroundImageView = ImageView()
    private let backButton = BackButton()
    private let screenTitle = Label(text: "New Work", textFont: .bold(ofSize: 40))
    private let titleView = View()
    private let titleTextField = TextField(placeHolder: "Enter task title", returnType: .next)
    private let descriptionView = View()
    private let descriptionTextField = TextField(placeHolder: "Enter task description", returnType: .done)
    private let dateTimePicker = DateTimePicker()
    private let selectImageText = Label(text: "Tap on view to select Image?", textFont: .regular())
    private let imagePickerView = ImagePickerView()
    private let addButton = Button(setTitle: "Add")
    
    private var db = Firestore.firestore()
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        setupViews()
        addTarget()
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        addButton.isUserInteractionEnabled = false
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
        view.addSubview(selectImageText)
        view.addSubview(imagePickerView)
        view.addSubview(addButton)
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
            
            descriptionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 25),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionView.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionTextField.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -20),
            descriptionTextField.topAnchor.constraint(equalTo: descriptionView.topAnchor),
            descriptionTextField.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor),
            
            dateTimePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateTimePicker.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20),
            
            addButton.widthAnchor.constraint(equalToConstant: 100),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.topAnchor.constraint(equalTo: dateTimePicker.bottomAnchor, constant: 25),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            selectImageText.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            selectImageText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            imagePickerView.widthAnchor.constraint(equalToConstant: 200),
            imagePickerView.heightAnchor.constraint(equalToConstant: 150),
            imagePickerView.topAnchor.constraint(equalTo: selectImageText.bottomAnchor, constant: 5),
            imagePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
        ])
    }
    private func addTarget() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        addButton.alpha = 0.5
        titleTextField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        descriptionTextField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        let tappedImageView = UITapGestureRecognizer(target: self, action: #selector(didTappedImageView))
        imagePickerView.addGestureRecognizer(tappedImageView)
        imagePickerView.isUserInteractionEnabled = true
    }

    @objc func addItem() {
        guard let currentUser = Auth.auth().currentUser?.uid else{
            return
        }
        let timestamp = Timestamp()
        let collection = db.collection("users").document(currentUser).collection("work")
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
        collection.addDocument(data: ["task_Title": titleTextField.text ?? "", "task_Description": descriptionTextField.text ?? "", "task_Date": changeDateTimeFormat(),"task_Image": path,"task_currentStatus": "Pending", "task_TimeStamp": timestamp]) { error in
            if let error = error {
                print("Task Not Added: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Save Unsuccessful", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("Data saved successfully")
                print("Date Stored as ", self.changeDateTimeFormat())
                let alert = UIAlertController(title: "Added Successful", message: "Task Added successfully.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
            }
            DispatchQueue.main.async {
                self.titleTextField.text = ""
                self.descriptionTextField.text = ""
                self.imagePickerView.image = nil
            }
        }
    }
    @objc func didTextFieldChanged() {
        let isaddEnabled = !titleTextField.text!.isEmpty && !descriptionTextField.text!.isEmpty
        addButton.isUserInteractionEnabled = true
        addButton.alpha = isaddEnabled ? 1.0 : 0.5
    }
    @objc func changeDateTimeFormat() -> String {// This Func Will Change The Format of Date To String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy h:mm a\nEEEE" //EEEE\nd MMMM yyyy\nh:mm a
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

extension AddItemController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
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
}

extension AddItemController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            titleTextField.becomeFirstResponder()
        }else {
            descriptionTextField.resignFirstResponder()
        }
        return true
    }
}
