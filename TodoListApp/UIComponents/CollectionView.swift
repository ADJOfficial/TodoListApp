//
//  CollectionView.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 18/07/2024.
//

import UIKit

class CollectionView: UICollectionView {
    init(backgroundColor: UIColor){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        super.init(frame: .zero, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
