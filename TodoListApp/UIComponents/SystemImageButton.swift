//
//  SFSymbolButton.swift
//  TodoListApp
//
//  Created by ADJ on 14/07/2024.
//

import UIKit

class SystemImageButton: UIButton {
    init(image: UIImage?, size: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20), tintColor: UIColor){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(image, for: .normal)
        self.setPreferredSymbolConfiguration(size, forImageIn: .normal)
        self.tintColor = tintColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
