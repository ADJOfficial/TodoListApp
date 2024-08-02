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
    private let verificationLabel = Label(text: "Verification", textFont: .bold(ofSize: 40))
    private let descriptionLabel = Label(text: "Enter verification code send to your authenticate phone number ••••••••077", textFont: .medium(ofSize: 15))
//    private let otpInputField = OTPTextField()
    private let verifyOTPButton = Button(setTitle: "Verify")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        addTargets()
//        didVerifyButtonTapped()
    }
    
    private func setUpViews() {
        view.addSubview(backgroundView)
        view.addSubview(screenTitle)
        view.addSubview(verificationLabel)
        view.addSubview(descriptionLabel)
//        view.addSubview(otpInputField)
        view.addSubview(verifyOTPButton)
        
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
            descriptionLabel.leadingAnchor.constraint(equalTo: verificationLabel.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
//            otpInputField.heightAnchor.constraint(equalToConstant: 50),
//            otpInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
//            otpInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
//            otpInputField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            verifyOTPButton.widthAnchor.constraint(equalToConstant: 150),
            verifyOTPButton.heightAnchor.constraint(equalToConstant: 50),
            verifyOTPButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verifyOTPButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    private func addTargets() {
        verifyOTPButton.addTarget(self, action: #selector(didVerifyButtonTapped), for: .touchUpInside)
    }
    
    @objc func didVerifyButtonTapped() {
        let phoneNo = "+923325354254"
        let otpCode = "123456"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNo, uiDelegate: nil) { verificationID , error in
            if let error = error {
                print("Error Sending OTP \(error.localizedDescription)")
            } else {
                print("OTP Send Successfull \(verificationID ?? "")")
            }
            let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "", verificationCode: otpCode)
            Auth.auth().signIn(with: credentials) { authData, error in
                if let error = error {
                    print("Invalid Credentials \(error.localizedDescription)")
                } else {
                    print("Valid Credentials \(String(describing: authData))")
                }
            }
        }
    }
}
