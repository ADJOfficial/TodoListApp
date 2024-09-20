//
//  AppDelegate.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 03/07/2024.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: WelcomeViewController())
        window?.rootViewController = nav
        nav.setNavigationBarHidden(true, animated: false)
        window?.makeKeyAndVisible()
        configureNotification()
        application.registerForRemoteNotifications()
        print("This Func Called : \(#function)")
        return true
    }
    private func configureNotification() {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            guard success else {
                print("Notification Permission Denied")
                return
            }
            print("Notification Permission Granted")
        }
    }
}
