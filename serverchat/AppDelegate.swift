//
//  AppDelegate.swift
//  serverchat
//
//  Created by David Oliver Doswell on 1/20/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)

        let starterViewController = StarterViewController()
        let navigationController = UINavigationController(rootViewController: starterViewController)
        self.window?.tintColor = UIColor.appColor()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        return true
    }

}

extension UIColor {
    class func appColor() -> UIColor {
        return UIColor(red: 139/255, green: 41/255, blue: 229/255, alpha: 1.0)
    }
    class func bubbleViewBackgroundColor() -> UIColor {
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
}

