//
//  GradientView.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 16/08/2024.
//

import UIKit

class GradientLayer: UIView {
    let gradientLayer = CAGradientLayer()
    init(viewCornerRadius: CGFloat = 22, layerCornerRadius: CGFloat = 22, backgroundColors: [UIColor]  = [UIColor.systemCyan.withAlphaComponent(0.1),UIColor.black.withAlphaComponent(0.5)]) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = viewCornerRadius
        gradientLayer.cornerRadius = layerCornerRadius
        self.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateGradientColors(_ colors: [UIColor]) {
        gradientLayer.colors = colors.map { $0.cgColor }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }

}
