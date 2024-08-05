//
//  LoginController.swift
//  FirstApp
//
//  Created by Arsalan Daud on 03/07/2024.
//


import UIKit
import Firebase
import Security
import LocalAuthentication

class LoginController: UIViewController {
    private let backgroundView = ImageView()
    private let titleLabel = Label(text: "O3 INTERFACES",textFont: .bold(ofSize: 40))
    private let headingLabel = Label(text: "Login Required",textFont: .bold(ofSize: 20))
    private let descriptionLabel = Label(text: "Please Sign in to continue.",textFont: .regular(ofSize: 15))
    private let faceID = SystemImageButton(image: UIImage(systemName: "faceid"),size: UIImage.SymbolConfiguration(pointSize: 60), tintColor: .systemGreen)
    private let emailFieldView = View()
    private let emailTextField = TextField(placeHolder: "Enter your email", returnType: .next)
    private let emailRequired = Label(text: "Required*", textColor: .systemRed, textFont: .bold(ofSize: 18))
    private let passwordFieldView = View()
    private let passwordTextField = TextField(placeHolder: "Enter your password", isScure: true, returnType: .done)
    private let showPassword = SystemImageButton(image: UIImage(systemName: "eye"), tintColor: .gray)
    private let passwordRequired = Label(text: "Required* ", textColor: .systemRed, textFont: .bold(ofSize: 18))
    private let signinButton = Button(setTitle: "Sign in")
    private let accountLabel = Label(text: "Don't have an account?", textFont: .bold(ofSize: 15))
    private let signupButton = Button(backgroungColor: .clear, cornerRadius: 0, setTitle: "Signup", setTitleColor: .blue)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addTargets()
        setupKeyboardLayout()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        signinButton.alpha = 0.5
        signinButton.isUserInteractionEnabled = false
        print("This Func is Called : \(#function)")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(titleLabel)
        view.addSubview(headingLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(faceID)
        view.addSubview(emailFieldView)
        emailFieldView.addSubview(emailTextField)
        view.addSubview(emailRequired)
        view.addSubview(passwordFieldView)
        passwordFieldView.addSubview(passwordTextField)
        view.addSubview(showPassword)
        view.addSubview(passwordRequired)
        view.addSubview(signinButton)
        view.addSubview(accountLabel)
        view.addSubview(signupButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -125),

            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor),
   
            emailFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailFieldView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailFieldView.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.leadingAnchor.constraint(equalTo: emailFieldView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: emailFieldView.trailingAnchor, constant: -20),
            emailTextField.topAnchor.constraint(equalTo: emailFieldView.topAnchor),
            emailTextField.bottomAnchor.constraint(equalTo: emailFieldView.bottomAnchor),

            emailRequired.topAnchor.constraint(equalTo: emailFieldView.bottomAnchor, constant: 5),
            emailRequired.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            passwordFieldView.topAnchor.constraint(equalTo: emailRequired.bottomAnchor, constant: 25),
            passwordFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordFieldView.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.leadingAnchor.constraint(equalTo: passwordFieldView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordFieldView.trailingAnchor, constant: -20),
            passwordTextField.topAnchor.constraint(equalTo: passwordFieldView.topAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordFieldView.bottomAnchor),

            showPassword.topAnchor.constraint(equalTo: passwordTextField.topAnchor),
            showPassword.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            showPassword.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            
            passwordRequired.topAnchor.constraint(equalTo: passwordFieldView.bottomAnchor, constant: 5),
            passwordRequired.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            signinButton.widthAnchor.constraint(equalToConstant: 150),
            signinButton.heightAnchor.constraint(equalToConstant: 50),
            signinButton.topAnchor.constraint(equalTo: passwordRequired.bottomAnchor, constant: 25),
            signinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            faceID.topAnchor.constraint(equalTo: signinButton.bottomAnchor, constant: 20),
            faceID.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            accountLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            accountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            signupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor ,constant: 7),
            signupButton.leadingAnchor.constraint(equalTo: accountLabel.trailingAnchor, constant: 10),
        ])
    }
    private func addTargets() {
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        signinButton.addTarget(self, action: #selector(userLogin), for: .touchUpInside)
        faceID.addTarget(self, action: #selector(signUpWithFaceID), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        showPassword.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
    }
    private func changeState() {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.emailRequired.text = "Required*"
        self.emailRequired.textColor = .systemRed
        self.passwordRequired.text = "Required*"
        self.passwordRequired.textColor = .systemRed
        self.signinButton.alpha = 0.5
        self.signinButton.isUserInteractionEnabled = false
    }
    private func saveCredentials() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Email or Password is Empty")
            return
        }
        do {
            try keychainService.saveCredentials(service: "Task.com", email: email, password: password.data(using: .utf8) ?? Data())
        }
        catch {
            print(error)
        }
    }

    @objc func eyeButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        let image = passwordTextField.isSecureTextEntry ? "eye" : "eye.fill"
        showPassword.setImage(UIImage(systemName: image), for: .normal)
    }
    @objc func textFieldDidChanged() {
        if emailTextField.isFirstResponder {
            validateEmail()
        } else if passwordTextField.isFirstResponder {
            validatePassword()
        }
        let isloginEnabled = emailRequired.textColor == .systemBlue && passwordRequired.textColor == .systemBlue
        signinButton.isUserInteractionEnabled = isloginEnabled
        signinButton.alpha = isloginEnabled ? 1.0 : 0.5
    }
    @objc func validateEmail() {
        if let email = emailTextField.text, !email.isEmpty {
            if isValidEmail(email: email) {
                emailRequired.text = "Valid Email"
                emailRequired.textColor = .systemBlue
            } else {
                emailRequired.text = "Invalid Email"
                emailRequired.textColor = .systemRed
            }
        }
        else {
            emailRequired.text = "Required*"
        }
    }
    @objc func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[com]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    @objc func validatePassword() {
        if let password = passwordTextField.text, !password.isEmpty {
            if isValidPassword(password: password){
                passwordRequired.text = "Valid Password"
                passwordRequired.textColor = .systemBlue
            } else {
                passwordRequired.text = "Invalid Password"
                passwordRequired.textColor = .systemRed
            }
        } else {
            passwordRequired.text = "Required*"
        }
    }
    @objc func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: password)
    }
    @objc func userLogin() {
        Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { result, error in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("Login successful")
                self.saveCredentials()
                self.loginButtonTapped()
                self.changeState()
            }
        }
    }
    @objc func signUpWithFaceID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate with Face ID to sign up") { success, error in
                if success {
                    Auth.auth().signIn(withEmail: "Arsalan1@gmail.com", password: "Arsalan1") { result, error in
                        if let error = error {
                            print("Login failed: \(error.localizedDescription)")
                            let alert = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .actionSheet)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            print("Login successful")
                            self.saveCredentials()
                            self.loginButtonTapped()
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
    @objc func signupButtonTapped() {
        let goToSignupController = SignupController()
        navigationController?.pushViewController(goToSignupController, animated: true)
        changeState()
    }
    @objc func loginButtonTapped() {
        let otpController = TodoListController()
        navigationController?.pushViewController(otpController, animated: true)
    }
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
