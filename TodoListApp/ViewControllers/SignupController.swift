//
//  SignupController.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 04/07/2024.
//


import UIKit
import Firebase

class SignupController: UIViewController {

    private let backgroundImageView = ImageView()
    private let backButton = BackButton()
    private let titleLabel = Label(text: "Sign up",textFont: .bold(ofSize: 40))
    private let headingLabel = Label(text: "Create an account",textFont: .bold(ofSize: 20))
    private let descriptionLabel = Label(text: "Please Sign up to continue", textFont: .regular(ofSize: 15))
    private let emailFieldView = View()
    private let emailTextField = TextField(placeHolder: "Enter your email", returnType: .next, keyboardType: .emailAddress)
    private let emailRequired = Label(text: "Required*", textColor: .systemRed, textFont: .bold(ofSize: 18))
    private let passwordFieldView = View()
    private let passwordTextField = TextField(placeHolder: "Enter your password", isSecure: true, returnType: .done)
    private let showPassword = SystemImageButton(image: UIImage(systemName: "eye"), tintColor: .gray)
    private let passwordRequired = Label(text: "Required*", textColor: .systemRed, textFont: .bold(ofSize: 18))
    private let signupButton = Button(setTitle: "Sign up")
    private let accountLabel = Label(text: "Already have a account?", textFont: .bold(ofSize: 15))
    private let loginButton = Button(backgroungColor: .clear, cornerRadius: 0, setTitle: "Login", setTitleColor: .blue)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        buttonTarget()
        setupKeyboardLayout()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        signupButton.alpha = 0.5
        signupButton.isUserInteractionEnabled = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(headingLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(emailFieldView)
        emailFieldView.addSubview(emailTextField)
        view.addSubview(emailRequired)
        view.addSubview(passwordFieldView)
        passwordFieldView.addSubview(passwordTextField)
        view.addSubview(showPassword)
        view.addSubview(passwordRequired)
        view.addSubview(signupButton)
        view.addSubview(accountLabel)
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            backButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor , constant: 20),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -125),
            
            descriptionLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
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
            
            passwordFieldView.topAnchor.constraint(equalTo: emailRequired.bottomAnchor, constant: 20),
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
            
            signupButton.widthAnchor.constraint(equalToConstant: 150),
            signupButton.heightAnchor.constraint(equalToConstant: 50),
            signupButton.topAnchor.constraint(equalTo: passwordFieldView.topAnchor, constant: 80),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
 
            accountLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            accountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65),
        ])
    }
    private func buttonTarget() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(userSignup), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        showPassword.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
    }
    private func validateEmail() {
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
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[com]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    private func validatePassword() {
        if let password = passwordTextField.text, !password.isEmpty {
            if isValidPassword(password: password) {
                passwordRequired.text = "Valid Password"
                passwordRequired.textColor = .systemBlue
            } else {
                passwordRequired.text = "Invalid Password"
                passwordRequired.textColor = .systemRed
            }
        }
    }
    private func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: password)
    }
    
    @objc func eyeButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        let image = passwordTextField.isSecureTextEntry ? "eye" : "eye.fill"
        showPassword.setImage(UIImage(systemName: image), for: .normal)
    }
    @objc func textFieldDidChange() {
        if emailTextField.isFirstResponder {
            validateEmail()
        } else if passwordTextField.isFirstResponder {
            validatePassword()
        }
        let isSignupEnabled = emailRequired.textColor == .systemBlue && passwordRequired.textColor == .systemBlue
        signupButton.isUserInteractionEnabled = isSignupEnabled
        signupButton.alpha = isSignupEnabled ? 1.0 : 0.5
    }
    @objc func userSignup() {
        Auth.auth().createUser(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { result, error in
            if let error = error {
                print("Sigup failed: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Signup Failed", message: error.localizedDescription, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("You Have Sign up successfully")
                let alert = UIAlertController(title: "Sign up Successful", message: "Tap on ok to Sign in", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
            }
            DispatchQueue.main.async {
                self.signupButton.alpha = 0.5
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            }
        }
    }
    @objc func loginButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension SignupController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
