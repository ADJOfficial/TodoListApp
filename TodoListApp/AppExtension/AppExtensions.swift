//
//  AppExtensions.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 19/07/2024.
//
import UIKit
// MARK: For Label Text Font Size Almost Used on All View
extension UIFont {
    static func medium(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .medium)
    }
    static func regular(ofSize: CGFloat = 25) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .regular)
    }
    static func bold(ofSize: CGFloat = 40) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .bold)
    }
}
// MARK: UIImage Used on Todolist Screen
extension UIImage {
    static func systemName(name: String = "plus.circle.fill") -> UIImage {
        return UIImage(systemName: name) ?? UIImage()
    }
    static func imageSize(size: CGFloat = 40) -> UIImage.SymbolConfiguration {
        return UIImage.SymbolConfiguration(pointSize: size)
    }
}
// MARK: For KeyboardAppear Event
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
        let keyboardisShowing = view.frame.origin.y == 0
        if keyboardisShowing {
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
// MARK: AutoSized According to Screen Size
extension Int {
    var autoSized: CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let diagonalSize = sqrt((screenWidth * screenWidth) + (screenHeight * screenHeight))
        let percentage = CGFloat(self)/980.0
        return diagonalSize * percentage/100
    }
    var widthRatio: CGFloat {
        let width = UIScreen.main.bounds.width/414.0
        return CGFloat(self)*width
    }
}
