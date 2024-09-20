//
//  ImagePickerView.swift
//  TodoListApp
//
//  Created by ADJ on 25/07/2024.
//

import UIKit

class ImagePickerView: UIImageView {
    var imageName: String = "" {
        didSet { // MARK: didSet is an Property Observer
            self.image = UIImage(named: imageName)
        }
    }
    init(backgroundColor: UIColor = .systemGray3, imageName: String = "", cornerRadius: CGFloat = 22, aspectRatio: ContentMode = .scaleAspectFill, bounds: Bool = true){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.imageName = imageName
        self.layer.cornerRadius = cornerRadius
        self.contentMode = aspectRatio
        self.clipsToBounds = bounds
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
