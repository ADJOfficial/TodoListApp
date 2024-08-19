//
//  UIView.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 12/08/2024.
//

import UIKit

class ManageUIViews: UIView {
    let genericTextField = TextField()
    init(placeholder: String, returnType: UIReturnKeyType = .default) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.genericTextField.placeholder = placeholder
        self.genericTextField.returnKeyType = returnType
        self.backgroundColor = .systemGray4
        self.layer.cornerRadius = 22
        self.setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(genericTextField)
        
        NSLayoutConstraint.activate([
            genericTextField.heightAnchor.constraint(equalToConstant: 50),
            genericTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            genericTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25)
        ])
    }
}



