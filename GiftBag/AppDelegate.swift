//
//  AppDelegate.swift
//  Firebase-boilerplate
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

typealias FIRUser = FirebaseAuth.User

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.sharedManager().enable = true
        configureInitialRootViewController(for: window)
        UINavigationBar.appearance().barTintColor = Styles.lightGreen
        if let font = UIFont(name: Styles.mainFont, size: 25) {
            let titleAtributes : [String : Any] = [NSFontAttributeName: font]
            UINavigationBar.appearance().titleTextAttributes = titleAtributes
        }
        return true
    }

}

extension AppDelegate {
    func configureInitialRootViewController(for window: UIWindow?) {
        let defaults = UserDefaults.standard
        let initialViewController: UIViewController
        
        if Auth.auth().currentUser != nil {
            if let userData = defaults.object(forKey: "currentUser") as? Data,
                let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User {
                User.setCurrent(user)
                initialViewController = UIStoryboard.initialViewController(for: .main)
            }
            else {
                AuthService.logUserOut(false)
                initialViewController = UIStoryboard.initialViewController(for: .login)
            }
        }
        else {
            initialViewController = UIStoryboard.initialViewController(for: .login)
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}
