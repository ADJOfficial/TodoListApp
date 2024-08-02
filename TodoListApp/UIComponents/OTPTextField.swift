//
//  OTPTextField.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 31/07/2024.
//

import UIKit

class OTPTextField: UITextField {
    init(backgroundColor: UIColor = .red, textColor: UIColor = .black, keyboardType: UIKeyboardType = .numberPad, contentMode: UITextContentType  = .oneTimeCode) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.keyboardType = keyboardType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
