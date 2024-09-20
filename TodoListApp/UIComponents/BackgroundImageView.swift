//
//  View.swift
//  TodoListApp
//
//  Created by ADJ on 13/07/2024.
//

import UIKit

class BackgroundImageView: UIImageView { // Named as Background Image View
    init(imageName: String = "firebase"){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = UIImage(named: imageName)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
