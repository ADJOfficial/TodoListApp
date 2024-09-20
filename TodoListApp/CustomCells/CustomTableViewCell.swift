//
//  CustomTableViewCell.swift
//  TodoListApp
//
//  Created by ADJ on 03/07/2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    let cellView = GradientLayer()
    private let detailsIcon = SystemImageButton(image: UIImage(systemName: "info.circle"), tintColor: .white)
    private let editView = EditTodoListView()
    private let deleteIcon = SystemImageButton(image: UIImage(systemName: "trash.fill"), tintColor: .red)
    let taskTitle = Label(text: "" , textColor: .darkGray, textFont: .bold(ofSize: 30))
    let editedWork = Label(text: "" , textFont: .medium(ofSize: 15))
    let taskDescription = Label(text: "", textFont: .bold(ofSize: 20))
    let taskImage = ImagePickerView()
    let taskDate = Label(text: "", textFont: .bold(ofSize: 15))
    
    var didTapEditButton: (()->Void)?
    var didDetailsIconTapped: (()-> Void)?
    var didTapDeleteButton: (()->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        addTargets()
        selectionStyle = .none
        self.backgroundColor = .clear
        editView.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        addSubview(cellView)
        cellView.addSubview(detailsIcon)
        cellView.addSubview(taskTitle)
        cellView.addSubview(editedWork)
        cellView.addSubview(taskDescription)
        cellView.addSubview(editView)
//        cellView.addSubview(taskImage)
//        cellView.addSubview(taskDate)
        cellView.addSubview(deleteIcon)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25.autoSized),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            detailsIcon.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 20.autoSized),
            detailsIcon.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -25.widthRatio),
            
            taskTitle.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10.autoSized),
            taskTitle.leadingAnchor.constraint(equalTo: cellView.leadingAnchor , constant: 20.widthRatio),
            
            editedWork.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5.autoSized),
            editedWork.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
            
            
            taskDescription.topAnchor.constraint(equalTo: taskTitle.bottomAnchor),
            taskDescription.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20.widthRatio),
            taskDescription.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -20.widthRatio),
            
//            taskImage.widthAnchor.constraint(equalToConstant: 150.widthRatio),
//            taskImage.heightAnchor.constraint(equalToConstant: 100.autoSized),
//            taskImage.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -25.autoSized),
//            taskImage.trailingAnchor.constraint(equalTo: deleteIcon.trailingAnchor, constant: -25.widthRatio),
            
//            taskDate.topAnchor.constraint(equalTo: taskDescription.bottomAnchor,constant: 25),
//            taskDate.leadingAnchor.constraint(equalTo: cellView.leadingAnchor,constant: 25),
            
            deleteIcon.topAnchor.constraint(equalTo: taskDescription.bottomAnchor, constant: 25.autoSized),
            deleteIcon.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -25.widthRatio),
            deleteIcon.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -25.autoSized),
            
            editView.topAnchor.constraint(equalTo: taskDescription.bottomAnchor, constant: 15.autoSized),
            editView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20.widthRatio),
        ])
    }
    private func addTargets() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didEditViewTapped))
        editView.addGestureRecognizer(tap)
        detailsIcon.addTarget(self, action: #selector(isDetailsIconTapped), for: .touchUpInside)
        deleteIcon.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc func didEditViewTapped() {
        didTapEditButton?()
        print("Edit View Pressed")
    }
    @objc func isDetailsIconTapped() {
        didDetailsIconTapped?()
        print("Details Button Pressed")
    }
    @objc func deleteButtonTapped() {
        didTapDeleteButton?()
        print("Delete Icon Pressed")
    }
}
