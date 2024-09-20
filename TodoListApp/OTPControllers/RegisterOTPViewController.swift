//
//  OTPViewController.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 31/07/2024.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterOTPViewController: UIViewController {
    
    private let backgroundView = BackgroundImageView()
    private let screenTitle = Label(text: "Required Phone", textFont: .bold())
    private let verificationLabel = Label(text: "Verification", textFont: .bold(ofSize: 30))
    private let descriptionLabel = Label(text: "Enter your Authenticate Phone Number that ends with number +92 •••••••077", textFont: .medium(ofSize: 15))
    private let phoneTextFieldView = TextFieldView(placeholder: "Enter phone number", returnType: .next, keyboardType: .phonePad)
    private let otpTextFieldView = TextFieldView(placeholder: "Enter OTP", returnType: .done, keyboardType: .phonePad)
    private let registerButton = Button(setTitle: "Register")
    private let loader = Loader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        addTargets()
        phoneTextFieldView.textField.delegate = self
        registerButton.alpha = 0.5
        registerButton.isUserInteractionEnabled = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setUpViews() {
        view.addSubview(backgroundView)
        view.addSubview(screenTitle)
        view.addSubview(verificationLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(phoneTextFieldView)
        view.addSubview(registerButton)
        view.addSubview(otpTextFieldView)
        view.addSubview(loader)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            verificationLabel.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 25),
            verificationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: verificationLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: verificationLabel.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            phoneTextFieldView.heightAnchor.constraint(equalToConstant: 50),
            phoneTextFieldView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            phoneTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            phoneTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),

            otpTextFieldView.heightAnchor.constraint(equalToConstant: 50),
            otpTextFieldView.topAnchor.constraint(equalTo: phoneTextFieldView.bottomAnchor, constant: 25),
            otpTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            otpTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            registerButton.widthAnchor.constraint(equalToConstant: 150),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.topAnchor.constraint(equalTo: otpTextFieldView.bottomAnchor, constant: 25),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 25)
        ])
    }
    private func addTargets() {
        registerButton.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
        phoneTextFieldView.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
//        otpTextFieldView.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
    }
    
    @objc func signinButtonTapped() {
        guard let email = phoneTextFieldView.textField.text, !email.isEmpty else {
//            showAlert(title: "Error", message: "Please enter an email address.")
            return
        }
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { (error) in
            if let error = error {
                print("Failed to Sigin \(error.localizedDescription)")
                return
            }
            
            print("Sign-in email link sent successfully.")
//            self.showAlert(title: "Success", message: "A sign-in link has been sent to your email address. Please check your inbox and click the link to sign in.")
        }
    }
    
    private var actionCodeSettings: ActionCodeSettings {
        let settings = ActionCodeSettings()
        settings.handleCodeInApp = true
        settings.url = URL(string: "https://o3interfacestodolistapp.page.link")
        settings.setIOSBundleID("xyabcabiksb.TodoListApp")
        return settings
    }
    @objc func didTextFieldChanged() {
        let isEnterText = phoneTextFieldView.textField.text?.isEmpty == false
        registerButton.alpha = isEnterText ? 1.0 : 0.5
        registerButton.isUserInteractionEnabled = isEnterText
    }
    @objc func didOTPVerifySuccessfully() {
        let todoList = SigninViewController()
        navigationController?.pushViewController(todoList, animated: true)
    }
}
extension RegisterOTPViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTextFieldView.textField {
            otpTextFieldView.textField.becomeFirstResponder()
        } else {
            otpTextFieldView.textField.resignFirstResponder()
        }
        return true
    }
}
