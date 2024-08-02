//
//  TableView.swift
//  TodoListApp
//
//  Created by ADJ on 14/07/2024.
//

import UIKit

class TableView: UITableView {
    init(backgroundColor: UIColor = .clear, separatorStyle: UITableViewCell.SeparatorStyle = .none){
        super.init(frame: .zero, style: .plain)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.separatorStyle = separatorStyle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
