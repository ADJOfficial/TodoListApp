//
//  AppExtensions.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 19/07/2024.
//
import UIKit

extension UIFont {
    static func medium(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .medium)
    }
    static func regular(ofSize: CGFloat = 15) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .regular)
    }
    static func bold(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .bold)
    }
}

extension UIImage {
    static func systemName(name: String = "plus.circle.fill") -> UIImage {
        return UIImage(systemName: name) ?? UIImage()
    }
    static func imageSize(size: CGFloat = 40) -> UIImage.SymbolConfiguration {
        return UIImage.SymbolConfiguration(pointSize: size)
    }
}

