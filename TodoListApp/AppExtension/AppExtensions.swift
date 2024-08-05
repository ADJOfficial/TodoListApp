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

extension UIViewController {
    func setupKeyboardLayout() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardWillShow(notification: Notification) {
        let responderKeyBoardType = UIResponder.keyboardFrameEndUserInfoKey
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[responderKeyBoardType] as? NSValue else {
            return
        }
        let keyboardIsHidden = view.frame.origin.y == 0
        if keyboardIsHidden {
            view.frame.origin.y -= keyboardFrame.cgRectValue.height
        }
    }
    @objc private func keyboardWillHidden(notification: Notification) {
        let keyboardIsHidden = view.frame.origin.y == 0
        if !keyboardIsHidden {
            view.frame.origin.y = 0
        }
    }
}
