//
//  View.swift
//  TodoListApp
//
//  Created by ADJ on 13/07/2024.
//

import UIKit

class ImageView: UIImageView {
    init(imageName: String = "firebase", tintColor: UIColor = .black){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = UIImage(named: imageName)
        self.tintColor = tintColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
