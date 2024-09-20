//
//  Button.swift
//  TodoListApp
//
//  Created by ADJ on 13/07/2024.
//

import UIKit

class Button: UIButton {
    
    init(backgroungColor: UIColor = .black, cornerRadius: CGFloat = 22, setTitle: String, setTitleColor: UIColor = .white){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroungColor
        self.layer.cornerRadius = cornerRadius
        self.setTitle(setTitle, for: .normal)
        self.setTitleColor(setTitleColor, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
