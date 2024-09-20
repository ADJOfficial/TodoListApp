//
//  AppExtensions.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 19/07/2024.
//

import UIKit
import KeychainSwift

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
// MARK: AutoSized According to Screen Size
extension Int {
    var autoSized: CGFloat {
        let baseDiagonal: CGFloat = 980.0
        let screenDiagonal = sqrt(pow(UIScreen.main.bounds.width, 2) + pow(UIScreen.main.bounds.height, 2))
        let scale = screenDiagonal / baseDiagonal
        return CGFloat(self) * scale
    }
    var widthRatio: CGFloat {
        let baseWidth: CGFloat = 414.0
        let screenWidth = UIScreen.main.bounds.width
        let scale = screenWidth / baseWidth
        return CGFloat(self) * scale
    }
}

// MARK: For Save Credentials in KeyChain
extension UIViewController {
    func storeCredentials(email: String, password: String) {
        let keychain = KeychainSwift()
        keychain.set(email, forKey: "userEmail")
        keychain.set(password, forKey: "userPassword")
        print("Stored User Credentails with email \(email) and password \(password)")
    }
    func retrieveCredentials() -> (email: String?, password: String?) {
        let keychain = KeychainSwift()
        let email = keychain.get("userEmail")
        let password = keychain.get("userPassword")
        print("Fetched User With Email : \(email ?? "") and Password \(password ?? "")")
        return (email, password)
    }
}
// MARK: For Alerts
extension UIViewController {
    func popupAlert(title: String?, message: String?, style: UIAlertController.Style = .alert, actionTitles: [String?], actionStyles: [UIAlertAction.Style?], actions: [((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
