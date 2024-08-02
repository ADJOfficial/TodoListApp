//
//  SearchTextField.swift
//  TodoListApp
//
//  Created by ADJ on 14/07/2024.
//

import UIKit

class SearchTextField: UITextField {
    
    init(backgroundColor: UIColor = .systemGray4, cornorRadius: CGFloat = 22, placeHolder: String = "Search task", returnType: UIReturnKeyType = .default) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornorRadius
        self.placeholder = placeHolder
        self.clearButtonMode = .whileEditing
        self.returnKeyType = returnType
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
