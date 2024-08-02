//
//  AppDelegate.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 03/07/2024.
//

import UIKit
import Firebase
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success , error in
            guard success else {
                print("Notification Permission Denied")
                return
            }
            print("Notification Permission Granted")
        }
        application.registerForRemoteNotifications()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: LoginController())
        window?.rootViewController = nav
        nav.setNavigationBarHidden(true, animated: false)
        window?.makeKeyAndVisible()
        print("This Func is called \(#function)")
        return true
    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        if Auth.auth().canHandleNotification(userInfo) {
//            Auth.auth().canHandleNotification(userInfo)
//            return
//        }
//    }
}
