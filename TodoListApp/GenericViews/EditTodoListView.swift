//
//  EditUIView.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 15/08/2024.
//

import UIKit

class EditTodoListView: UIView {
    private let editLabel = Label(text: "Edit", textFont: .bold(ofSize: 15))
    private let editIcon = BackgroundImageView(imageName: "iconEdit")
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        self.backgroundColor = .systemGray4.withAlphaComponent(0.5)
        self.layer.cornerRadius = 22
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(editLabel)
        addSubview(editIcon)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 80.widthRatio),
            self.heightAnchor.constraint(equalToConstant: 50.autoSized),
            
            editLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.widthRatio),
            editLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            editIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15.widthRatio),
            editIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
