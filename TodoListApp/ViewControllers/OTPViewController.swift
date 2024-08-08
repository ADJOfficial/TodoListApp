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
    private let screenTitle = Label(text: "Security Required", textFont: .bold())
    private let backButton = BackButton()
    private let verificationLabel = Label(text: "Verification", textFont: .bold(ofSize: 30))
    private let descriptionLabel = Label(text: "Enter your Authenticate Phone Number that ends with number +92 •••••••077", textFont: .medium(ofSize: 15))
    private let phoneFieldView = View()
    private let phoneTextField = TextField(placeHolder: "Enter your phone number", returnType: .next, keyboardType: .phonePad)
    private let otpFieldView = View()
    private let otpTextField = TextField(placeHolder: "Enter OTP", returnType: .done, keyboardType: .phonePad)
    private let verifyButton = Button(setTitle: "Verify")
    private let loader = Loader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        addTargets()
        phoneTextField.delegate = self
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
        view.addSubview(phoneFieldView)
        phoneFieldView.addSubview(phoneTextField)
        view.addSubview(verifyButton)
        view.addSubview(otpFieldView)
        otpFieldView.addSubview(otpTextField)
        view.addSubview(loader)
        
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
            
            phoneFieldView.heightAnchor.constraint(equalToConstant: 50),
            phoneFieldView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 25),
            phoneFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            phoneFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            phoneTextField.topAnchor.constraint(equalTo: phoneFieldView.topAnchor),
            phoneTextField.bottomAnchor.constraint(equalTo: phoneFieldView.bottomAnchor),
            phoneTextField.leadingAnchor.constraint(equalTo: phoneFieldView.leadingAnchor, constant: 25),
            phoneTextField.trailingAnchor.constraint(equalTo: phoneFieldView.trailingAnchor, constant: -25),
            
            otpFieldView.widthAnchor.constraint(equalToConstant: 250),
            otpFieldView.heightAnchor.constraint(equalToConstant: 50),
            otpFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            otpFieldView.topAnchor.constraint(equalTo: phoneFieldView.bottomAnchor, constant: 25),
            
            otpTextField.topAnchor.constraint(equalTo: otpFieldView.topAnchor),
            otpTextField.bottomAnchor.constraint(equalTo: otpFieldView.bottomAnchor),
            otpTextField.leadingAnchor.constraint(equalTo: otpFieldView.leadingAnchor, constant: 20),
            otpTextField.trailingAnchor.constraint(equalTo: otpFieldView.trailingAnchor, constant: -20),
            
            verifyButton.widthAnchor.constraint(equalToConstant: 150),
            verifyButton.heightAnchor.constraint(equalToConstant: 50),
            verifyButton.topAnchor.constraint(equalTo: otpFieldView.bottomAnchor, constant: 25),
            verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 25)
        ])
    }
    private func addTargets() {
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
        verifyButton.addTarget(self, action: #selector(didVerifyButtonTapped), for: .touchUpInside)
        phoneTextField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        otpTextField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
    }
    
    @objc func didTextFieldChanged() {
        let isEnterText = phoneTextField.text?.isEmpty == false && otpTextField.text?.isEmpty == false
        verifyButton.alpha = isEnterText ? 1.0 : 0.5
        verifyButton.isUserInteractionEnabled = isEnterText
    }
    @objc func didVerifyButtonTapped() {
        let phoneNo = "+92 \(phoneTextField.text ?? "")"
        let otpCode = "\(otpTextField.text ?? "")"
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
        let todoList = LoginViewController()
        navigationController?.pushViewController(todoList, animated: true)
    }
    @objc func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
extension OTPViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTextField {
            otpTextField.becomeFirstResponder()
        } else {
            otpTextField.resignFirstResponder()
        }
        return true
    }
}
