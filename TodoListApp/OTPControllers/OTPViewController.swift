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
    
    private let backgroundView = BackgroundImageView()
    private let screenTitle = Label(text: "Security Required", textFont: .bold())
    private let backButton = BackButton()
    private let verificationLabel = Label(text: "Verification", textFont: .bold(ofSize: 30))
    private let descriptionLabel = Label(text: "Enter your Authenticate Phone Number that ends with number +92 •••••••077", textFont: .medium(ofSize: 15))
    private let phoneTextFieldView = TextFieldView(placeholder: "Enter phone number", returnType: .next, keyboardType: .phonePad)
    private let otpTextFieldView = TextFieldView(placeholder: "Enter OTP", returnType: .done, keyboardType: .phonePad)
    private let verifyButton = Button(setTitle: "Verify")
    private let loader = Loader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        addTargets()
        phoneTextFieldView.textField.delegate = self
        verifyButton.alpha = 0.5
        verifyButton.isUserInteractionEnabled = false
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
        view.addSubview(phoneTextFieldView)
        view.addSubview(verifyButton)
        view.addSubview(otpTextFieldView)
        view.addSubview(loader)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            verificationLabel.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 25),
            verificationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: verificationLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: verificationLabel.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            phoneTextFieldView.heightAnchor.constraint(equalToConstant: 50),
            phoneTextFieldView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 25),
            phoneTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            phoneTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),

            otpTextFieldView.heightAnchor.constraint(equalToConstant: 50),
            otpTextFieldView.topAnchor.constraint(equalTo: phoneTextFieldView.bottomAnchor, constant: 25),
            otpTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            otpTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),

            verifyButton.topAnchor.constraint(equalTo: otpTextFieldView.bottomAnchor, constant: 25),
            verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 25)
        ])
    }
    private func addTargets() {
        verifyButton.addTarget(self, action: #selector(didVerifyButtonTapped), for: .touchUpInside)
        phoneTextFieldView.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        otpTextFieldView.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
    }
    
    @objc func didTextFieldChanged() {
        let isEnterText = phoneTextFieldView.textField.text?.isEmpty == false && otpTextFieldView.textField.text?.isEmpty == false
        verifyButton.alpha = isEnterText ? 1.0 : 0.5
        verifyButton.isUserInteractionEnabled = isEnterText
    }
    @objc func didVerifyButtonTapped() {
        let phoneNo = "+92 \(phoneTextFieldView.textField.text ?? "")"
        let otpCode = "\(otpTextFieldView.textField.text ?? "")"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNo, uiDelegate: nil) { verificationID , error in
            if let error = error {
                print("Ur Phone no is \(phoneNo)")
                print("Error Sending OTP \(error.localizedDescription)")
            } else {
                self.loader.startAnimating()
                print("OTP Send Successfull \(verificationID ?? "")")
            }
            let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "", verificationCode: otpCode)
            Auth.auth().signIn(with: credentials) { authData, error in
                if let error = error {
                    print("Invalid Credentials \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Invalid Phone Number", message: "The Number / OTP you have provide is not valid or not registered", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    self.loader.stopAnimating()
                } else {
                    self.loader.stopAnimating()
                    self.didOTPVerifySuccessfully()
                    print("Valid Credentials \(String(describing: authData))")
                }
            }
        }
    }
    @objc func didOTPVerifySuccessfully() {
        let todoList = SigninViewController()
        navigationController?.pushViewController(todoList, animated: true)
    }
}
extension OTPViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTextFieldView.textField {
            otpTextFieldView.textField.becomeFirstResponder()
        } else {
            otpTextFieldView.textField.resignFirstResponder()
        }
        return true
    }
}
