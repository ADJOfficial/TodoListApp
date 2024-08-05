//
//  OTPViewController.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 31/07/2024.
//

import UIKit
import Firebase
import FirebaseAuth

class OTPViewController: UIViewController {
    
    private let backgroundView = ImageView()
    private let screenTitle = Label(text: "Security", textFont: .bold(ofSize: 40))
    private let backButton = BackButton()
    private let verificationLabel = Label(text: "Verification", textFont: .bold(ofSize: 30))
    private let descriptionLabel = Label(text: "Enter your Authenticate Phone Number that ends with number ••••••••077", textFont: .medium(ofSize: 15))
    private let otpFieldView = View()
    private let otpTextField = TextField(placeHolder: "Enter your phone number", returnType: .done)
    private let verifyOTPButton = Button(setTitle: "Verify")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        addTargets()
        otpTextField.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setUpViews() {
        view.addSubview(backgroundView)
        view.addSubview(screenTitle)
        view.addSubview(backButton)
        view.addSubview(verificationLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(otpFieldView)
        otpFieldView.addSubview(otpTextField)
        view.addSubview(verifyOTPButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 25),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            verificationLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 25),
            verificationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: verificationLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: verificationLabel.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            otpFieldView.heightAnchor.constraint(equalToConstant: 50),
            otpFieldView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 25),
            otpFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            otpFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            otpTextField.topAnchor.constraint(equalTo: otpFieldView.topAnchor),
            otpTextField.bottomAnchor.constraint(equalTo: otpFieldView.bottomAnchor),
            otpTextField.leadingAnchor.constraint(equalTo: otpFieldView.leadingAnchor, constant: 25),
            otpTextField.trailingAnchor.constraint(equalTo: otpFieldView.trailingAnchor, constant: -25),
            
            verifyOTPButton.widthAnchor.constraint(equalToConstant: 150),
            verifyOTPButton.heightAnchor.constraint(equalToConstant: 50),
            verifyOTPButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verifyOTPButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    private func addTargets() {
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
        verifyOTPButton.addTarget(self, action: #selector(didVerifyButtonTapped), for: .touchUpInside)
    }
    
    @objc func didVerifyButtonTapped() {
        let phoneNo = otpTextField.text ?? ""
        let otpCode = "123123"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNo, uiDelegate: nil) { verificationID , error in
            if let error = error {
                print("Ur Phone no is \(phoneNo)")
                print("Error Sending OTP \(error.localizedDescription)")
            } else {
                print("OTP Send Successfull \(verificationID ?? "")")
            }
            let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "", verificationCode: otpCode)
            Auth.auth().signIn(with: credentials) { authData, error in
                if let error = error {
                    print("Invalid Credentials \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Invalid Phone Number", message: "The number you have provide is not valid or not registered", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    self.didOTPVerifySuccessfully()
                    print("Valid Credentials \(String(describing: authData))")
                }
            }
        }
    }
    @objc func didOTPVerifySuccessfully() {
        let todoList = TodoListController()
        navigationController?.pushViewController(todoList, animated: true)
    }
    @objc func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension OTPViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
