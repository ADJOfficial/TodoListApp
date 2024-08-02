//
//  TextFieldView.swift
//  TodoListApp
//
//  Created by ADJ on 13/07/2024.
//

import UIKit

class View: UIView {
    
    init(backgroundColor: UIColor = .systemGray4 , cornerRadius: CGFloat = 22, tintColor: UIColor = .black) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
