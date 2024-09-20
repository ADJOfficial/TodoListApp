//
//  SearchTextField.swift
//  TodoListApp
//
//  Created by ADJ on 14/07/2024.
//

import UIKit

class SearchBar: UISearchBar {
    init(backgroundColor: UIColor = .systemGray2, cornerRadius: CGFloat = 22, placeholder: String = "Search") {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.placeholder = placeholder
        self.searchBarStyle = .minimal
        self.sizeToFit()
        self.isTranslucent = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
