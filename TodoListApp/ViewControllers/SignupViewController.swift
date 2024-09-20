//
//  SignupController.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 04/07/2024.
//


import UIKit
import FirebaseAuth

class SignupViewController: BaseViewController {
    private let backButton = BackButton()
    private let screenLabel = Label(text: "Sign up", textFont: .bold())
    private let headingLabel = Label(text: "Create an account",textFont: .bold(ofSize: 20))
    private let descriptionLabel = Label(text: "Please Sign up to continue", textFont: .regular(ofSize: 15))
    private let emailTextFieldView = TextFieldView(placeholder: "Enter your email", returnType: .next, keyboardType: .emailAddress)
    private let passwordTextFieldView = TextFieldView(placeholder: "Enter your password", isSecure: true, returnType: .done)
    private let showPassword = SystemImageButton(image: UIImage(systemName: "eye"), tintColor: .gray)
    private let signupButton = Button(setTitle: "Sign up")
    private let accountLabel = Label(text: "Already have a account?", textFont: .medium(ofSize: 18))
    private let signinLabel = Label(text: "Login", textFont: .bold(ofSize: 20))

    var headingLabelTopContraints: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
        addObserver()
        signupButton.alpha = 0.5
        signupButton.isUserInteractionEnabled = false
        signinLabel.isUserInteractionEnabled = true
        emailTextFieldView.textField.delegate = self
        passwordTextFieldView.textField.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(screenLabel)
        view.addSubview(backButton)
        view.addSubview(headingLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(emailTextFieldView)
        view.addSubview(passwordTextFieldView)
        view.addSubview(showPassword)
        view.addSubview(signupButton)
        view.addSubview(accountLabel)
        view.addSubview(signinLabel)
        
        NSLayoutConstraint.activate([
            screenLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5.autoSized),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5.widthRatio),

            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            descriptionLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            emailTextFieldView.heightAnchor.constraint(equalToConstant: 50.autoSized),
            emailTextFieldView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 25.autoSized),
            emailTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            emailTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            passwordTextFieldView.heightAnchor.constraint(equalToConstant: 50.autoSized),
            passwordTextFieldView.topAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: 25.autoSized),
            passwordTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            passwordTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
  
            showPassword.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor),
            showPassword.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor),
            showPassword.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -15.widthRatio),
            
            signupButton.widthAnchor.constraint(equalToConstant: 150.widthRatio),
            signupButton.heightAnchor.constraint(equalToConstant: 50.autoSized),
            signupButton.topAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: 25.autoSized),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
 
            accountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            accountLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            signinLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 1.autoSized),
            signinLabel.leadingAnchor.constraint(equalTo: accountLabel.trailingAnchor, constant: 10.widthRatio),
        ])
        headingLabelTopContraints = headingLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -25.autoSized)
        headingLabelTopContraints?.isActive = true
    }
    private func addTarget() {
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
        showPassword.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(userSignup), for: .touchUpInside)
        emailTextFieldView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextFieldView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didSiginLabelTapped))
        signinLabel.addGestureRecognizer(gesture)
    }
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[com]{2,3}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    private func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: password)
    }

    @objc func eyeButtonTapped() {
        passwordTextFieldView.textField.isSecureTextEntry.toggle()
        let image = passwordTextFieldView.textField.isSecureTextEntry ? "eye" : "eye.fill"
        showPassword.setImage(UIImage(systemName: image), for: .normal)
    }
    @objc func textFieldDidChange() {
        let isSignupEnabled = isValidEmail(email: emailTextFieldView.textField.text ?? "") && isValidPassword(password: passwordTextFieldView.textField.text ?? "")
        signupButton.isUserInteractionEnabled = isSignupEnabled
        signupButton.alpha = isSignupEnabled ? 1.0 : 0.5
    }
    @objc func userSignup() {
        guard let email = emailTextFieldView.textField.text, let password = passwordTextFieldView.textField.text else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Signup failed: \(error.localizedDescription)")
                self.popupAlert(title: "Signup Failed", message: error.localizedDescription, style: .actionSheet, actionTitles: ["Try Again"], actionStyles: [.cancel], actions: [{ action in
                    print("Try Again")
                }])
            } else {
                print("You have signed up successfully")
                self.storeCredentials(email: email, password: password)
                self.popupAlert(title: "Sign up Successful", message: "One step left You need to signin to your app", actionTitles: ["Sigin Now"], actionStyles: [.default], actions: [{ action in
                    let siginController = SigninViewController()
                    self.navigationController?.pushViewController(siginController, animated: true)
                }])
            }
        }
    }
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardisShowing = view.frame.origin.y == 0
        if keyboardisShowing {
            UIView.animate(withDuration: 0.4) {
                self.headingLabelTopContraints?.constant = -180
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHidden(notification: Notification) {
        let keyboardIsHidden = view.frame.origin.y == 0
        if keyboardIsHidden {
            UIView.animate(withDuration: 0.2) {
                self.headingLabelTopContraints?.constant = -25
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func didSiginLabelTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextFieldView.textField {
            passwordTextFieldView.textField.becomeFirstResponder()
        } else {
            passwordTextFieldView.textField.resignFirstResponder()
        }
        return true
    }
}
