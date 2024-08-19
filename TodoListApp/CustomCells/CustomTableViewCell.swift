//
//  CustomTableViewCell.swift
//  TodoListApp
//
//  Created by ADJ on 03/07/2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    let cellView = GradientView()
    private let detailsIcon = SystemImageButton(image: UIImage(systemName: "info.circle"), tintColor: .systemBlue)
    private let editView = EditUIView()
    private let deleteIcon = SystemImageButton(image: UIImage(systemName: "trash.fill"), tintColor: .red)
    let taskTitle = Label(textColor: .darkGray, textFont: .bold(ofSize: 30))
    let taskDescription = Label(textFont: .bold(ofSize: 20))
    let taskImage = ImagePickerView()
    let taskDate = Label(textFont: .bold(ofSize: 15))
    
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
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        cellView.layer.sublayers?.first?.frame = cellView.bounds
//    }
    private func setupCell() {
        addSubview(cellView)
        cellView.addSubview(detailsIcon)
        cellView.addSubview(taskTitle)
        cellView.addSubview(taskDescription)
        cellView.addSubview(editView)
//        cellView.addSubview(taskImage)
//        cellView.addSubview(taskDate)
//        cellView.addSubview(editView)
//        editView.addSubview(editLabel)
//        editView.addSubview('editIcon')
        cellView.addSubview(deleteIcon)
        NSLayoutConstraint.activate([
//            cellView.widthAnchor.constraint(equalToConstant: 300),
//            cellView.heightAnchor.constraint(equalToConstant: 200),
            cellView.topAnchor.constraint(equalTo: self.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            cellView.topAnchor.constraint(equalTo: self.topAnchor),
//            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
            
            detailsIcon.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 20),
            detailsIcon.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -25),
            
            taskTitle.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10),
            taskTitle.leadingAnchor.constraint(equalTo: cellView.leadingAnchor , constant: 20),
            
            taskDescription.topAnchor.constraint(equalTo: taskTitle.bottomAnchor, constant: 20),
            taskDescription.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 25),
            taskDescription.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -20),
            
//            taskImage.widthAnchor.constraint(equalToConstant: 250),
//            taskImage.heightAnchor.constraint(equalToConstant: 200),
//            taskImage.topAnchor.constraint(equalTo: taskDescription.bottomAnchor, constant: 20),
//            taskImage.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -25),
//            
//            taskDate.topAnchor.constraint(equalTo: taskDescription.bottomAnchor,constant: 25),
//            taskDate.leadingAnchor.constraint(equalTo: cellView.leadingAnchor,constant: 25),
            
            deleteIcon.topAnchor.constraint(equalTo: taskDescription.bottomAnchor, constant: 25),
            deleteIcon.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -25),
            deleteIcon.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -25),
            
            editView.topAnchor.constraint(equalTo: taskDescription.bottomAnchor, constant: 15),
//            editView.bottomAnchor.constraint(equalTo: cellView.topAnchor, constant: 25),
            editView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 25),
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
