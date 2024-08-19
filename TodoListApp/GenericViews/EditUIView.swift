//
//  EditUIView.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 15/08/2024.
//

import UIKit

class EditUIView: UIView {
    private let editView = View(backgroundColor: .systemGray3)
    private let editLabel = Label(text: "Edit", textFont: .bold(ofSize: 15))
    private let editIcon = ImageView(imageName: "iconEdit")
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        editView.isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(editView)
        editView.addSubview(editLabel)
        editView.addSubview(editIcon)
        
        NSLayoutConstraint.activate([
            editView.widthAnchor.constraint(equalToConstant: 80),
            editView.heightAnchor.constraint(equalToConstant: 50),
            
            editLabel.leadingAnchor.constraint(equalTo: editView.leadingAnchor, constant: 20),
            editLabel.centerYAnchor.constraint(equalTo: editView.centerYAnchor),
            
            editIcon.trailingAnchor.constraint(equalTo: editView.trailingAnchor, constant: -15),
            editIcon.centerYAnchor.constraint(equalTo: editView.centerYAnchor)
        ])
    }
}
