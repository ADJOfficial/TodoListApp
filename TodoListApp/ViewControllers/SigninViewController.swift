//
//  LoginController.swift
//  FirstApp
//
//  Created by Arsalan Daud on 03/07/2024.
//


import UIKit
import FirebaseAuth
import LocalAuthentication

class SigninViewController: BaseViewController {
    private let titleLabel = Label(text: "O3 INTERFACES", textFont: .bold())
    private let backButton = BackButton()
    private let headingLabel = Label(text: "Signin Required",textFont: .bold(ofSize: 20))
    private let descriptionLabel = Label(text: "Please Sign in to continue.",textFont: .regular(ofSize: 15))
    private let faceIDView = View(backgroundColor: .black)
    private let faceIDSymbol = SystemImageButton(image: UIImage(systemName: "faceid"), size: UIImage.SymbolConfiguration(pointSize: 40), tintColor: .white)
    private let emailTextFieldView = TextFieldView(placeholder: "Enter your email", returnType: .next, keyboardType: .emailAddress)
    private let passwordTextFieldView = TextFieldView(placeholder: "Enter your password", isSecure: true, returnType: .done)
    private let showPassword = SystemImageButton(image: UIImage(systemName: "eye"), tintColor: .gray)
    private let signinButton = Button(setTitle: "Sign in")
    private let accountLabel = Label(text: "Don't have an account?", textFont: .medium(ofSize: 18))
    private let signupLabel = Label(text: "Sign up", textFont: .bold(ofSize: 21))

    var headingLabelTopConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        addObserver()
        signinButton.alpha = 0.5
        signinButton.isUserInteractionEnabled = false
        signupLabel.isUserInteractionEnabled = true
        emailTextFieldView.textField.delegate = self
        passwordTextFieldView.textField.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(headingLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(faceIDView)
        faceIDView.addSubview(faceIDSymbol)
        view.addSubview(emailTextFieldView)
        view.addSubview(passwordTextFieldView)
        view.addSubview(showPassword)
        view.addSubview(signinButton)
        view.addSubview(accountLabel)
        view.addSubview(signupLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5.autoSized),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5.widthRatio),
            
            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),

            descriptionLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
   
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
           
            faceIDView.widthAnchor.constraint(equalToConstant: 80.widthRatio),
            faceIDView.heightAnchor.constraint(equalToConstant: 70.autoSized),
            faceIDView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            faceIDView.topAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: 25.autoSized),
            
            faceIDSymbol.centerXAnchor.constraint(equalTo: faceIDView.centerXAnchor),
            faceIDSymbol.centerYAnchor.constraint(equalTo: faceIDView.centerYAnchor),
            
            signinButton.widthAnchor.constraint(equalToConstant: 150.widthRatio),
            signinButton.heightAnchor.constraint(equalToConstant: 50.autoSized),
            signinButton.topAnchor.constraint(equalTo: faceIDSymbol.bottomAnchor, constant: 25.autoSized),
            signinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            accountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            accountLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            signupLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 1.autoSized),
            signupLabel.leadingAnchor.constraint(equalTo: accountLabel.trailingAnchor, constant: 10.widthRatio),
        ])
        headingLabelTopConstraint = headingLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -25.autoSized)
        headingLabelTopConstraint?.isActive = true
    }
    private func addTargets() {
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
        showPassword.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        signinButton.addTarget(self, action: #selector(userSigin), for: .touchUpInside)
        faceIDSymbol.addTarget(self, action: #selector(signinWithFaceID), for: .touchUpInside)
        emailTextFieldView.textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        passwordTextFieldView.textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didSignupButtonTapped))
        signupLabel.addGestureRecognizer(gesture)
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
    private func didSigninSuccessful() {
        let otpController = TodoListViewController()
        navigationController?.pushViewController(otpController, animated: true)
    }
    private func changeState() {
        self.emailTextFieldView.textField.text = ""
        self.passwordTextFieldView.textField.text = ""
        self.signinButton.alpha = 0.5
        self.signinButton.isUserInteractionEnabled = false
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardisShowing = view.frame.origin.y == 0
        if keyboardisShowing {
            UIView.animate(withDuration: 0.3) {
                self.headingLabelTopConstraint?.constant = -270
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHidden(notification: Notification) {
        let keyboardIsHidden = view.frame.origin.y == 0
        if keyboardIsHidden {
            UIView.animate(withDuration: 0.3) {
                self.headingLabelTopConstraint?.constant = -25
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func eyeButtonTapped() {
        passwordTextFieldView.textField.isSecureTextEntry.toggle()
        let image = passwordTextFieldView.textField.isSecureTextEntry ? "eye" : "eye.fill"
        showPassword.setImage(UIImage(systemName: image), for: .normal)
    }
    @objc func textFieldDidChanged() {
        let isValidEntry = isValidEmail(email: emailTextFieldView.textField.text ?? "")
                        && isValidPassword(password: passwordTextFieldView.textField.text ?? "")
        signinButton.isUserInteractionEnabled = isValidEntry
        signinButton.alpha = isValidEntry ? 1.0 : 0.5
    }
    @objc func userSigin() {
        Auth.auth().signIn(withEmail: emailTextFieldView.textField.text ?? "", password: passwordTextFieldView.textField.text ?? "") { result, error in
            if let error = error as? NSError {
                var errorMessage = ""
                if error.code == 17008 {
                    errorMessage = "Incorrect Email. Please try again."
                } else if error.code == 17004 {
                    errorMessage = "Incorrect Password. Please try again."
                } else {
                    errorMessage = error.localizedDescription
                }
                self.popupAlert(title: "Sigin Failed", message: errorMessage, style: .actionSheet, actionTitles: ["Try Again"], actionStyles: [.cancel], actions: [{ action in
                    print("Try Again")
                }])
            } else {
                print("Sigin successful")
                self.didSigninSuccessful()
                self.changeState()
            }
        }
    }
    @objc func signinWithFaceID() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate with Face ID to sign up") { success, error in
                if success {
                    let credentials = self.retrieveCredentials()
                    Auth.auth().signIn(withEmail: credentials.email ?? "", password: credentials.password ?? "") { result, error in
                        if let error = error  {
                            print("Sigin failed: \(error.localizedDescription)")
                            self.popupAlert(title: "Sigin Failed", message: error.localizedDescription, style: .actionSheet, actionTitles: ["Try Again"], actionStyles: [.cancel], actions: [{ action in
                                print("Try Again")
                            }])
                        } else {
                            print("Sigin Successful with Email : \(credentials.email ?? "") and Password \(credentials.password ?? "")")
                            let controller = TodoListViewController()
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                    print("User Sign in successfully with Face ID")
                } else if let error = error  {
                    print("Face ID authentication failed: \(error.localizedDescription)")
                }
            }
        } else {
            print("Face ID not available on this device")
        }
    }
    @objc func didSignupButtonTapped(_ gesture: UITapGestureRecognizer) {
        let goToSignupController = SignupViewController()
        navigationController?.pushViewController(goToSignupController, animated: true)
        changeState()
    }
    @objc func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension SigninViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextFieldView.textField {
            passwordTextFieldView.textField.becomeFirstResponder()
        } else {
            passwordTextFieldView.textField.resignFirstResponder()
        }
        return true
    }
}
