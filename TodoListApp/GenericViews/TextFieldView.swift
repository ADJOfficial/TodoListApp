//
//  TextFieldView.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 12/08/2024.
//

import UIKit

class TextFieldView: UIView {
    
    let textField = TextField()
    
    init(placeholder: String = "", isSecure: Bool = false, returnType: UIReturnKeyType = .default, keyboardType: UIKeyboardType = .default) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textField.isSecureTextEntry = isSecure
        self.textField.placeholder = placeholder
        self.textField.returnKeyType = returnType
        self.textField.keyboardType = keyboardType
        self.backgroundColor = .systemGray4
        self.layer.cornerRadius = 22
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25.widthRatio),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25.widthRatio),
        ])
    }
}



