//
//  Loader.swift
//  TodoListApp
//
//  Created by ADJ on 18/07/2024.
//

import UIKit

class Loader: UIActivityIndicatorView {
    init(){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.color = .black
        self.style = .large
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
