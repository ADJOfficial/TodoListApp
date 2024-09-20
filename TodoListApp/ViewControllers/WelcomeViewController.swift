//
//  OTPViewController.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 31/07/2024.
//
import UIKit

class WelcomeViewController: BaseViewController {
    private let screenTitle = Label(text: "Welcome", textFont: .bold())
    private let verificationLabel = Label(text: "{ W }", textFont: .bold(ofSize: 30))
    private let welcomeLabel = Label(text: "Welcome to the new Work-List", textFont: .bold(ofSize: 20))
    private let descriptionLabel = Label(text: "The new level of \n features in our app", textFont: .medium(ofSize: 12))
    private let signinButton = Button(setTitle: "Sign in")
    private let signupButton = Button(setTitle: "Sign up")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(screenTitle)
        view.addSubview(verificationLabel)
        view.addSubview(welcomeLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(signinButton)
        view.addSubview(signupButton)
        
        NSLayoutConstraint.activate([  
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        
            verificationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25.autoSized),
            verificationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),

            welcomeLabel.topAnchor.constraint(equalTo: verificationLabel.bottomAnchor, constant: 25.autoSized),
            welcomeLabel.leadingAnchor.constraint(equalTo: verificationLabel.leadingAnchor),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10.autoSized),
            descriptionLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor, constant: 25.widthRatio),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            signinButton.widthAnchor.constraint(equalToConstant: 150.widthRatio),
            signinButton.heightAnchor.constraint(equalToConstant: 50.autoSized),
            signinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signinButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 25.autoSized),
            
            signupButton.widthAnchor.constraint(equalToConstant: 150.widthRatio),
            signupButton.heightAnchor.constraint(equalToConstant: 50.autoSized),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: signinButton.bottomAnchor, constant: 25.autoSized),
        ])
    }
    private func addTargets() {
        signinButton.addTarget(self, action: #selector(didTappedSigninButton), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(didTappedSignupButton), for: .touchUpInside)
    }
    
    @objc func didTappedSigninButton() {
        let signinController = SigninViewController()
        navigationController?.pushViewController(signinController, animated: true)
    }
    @objc func didTappedSignupButton() {
        let signupController = SignupViewController()
        navigationController?.pushViewController(signupController, animated: true)
    }
}
