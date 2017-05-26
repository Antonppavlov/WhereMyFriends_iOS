//
//  AppDelegate.swift
//  WhereMyFriends
//
//  Created by Anton Pavlov on 25.05.17.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let storage = LoginStorage()
    
    
    override init() {
        FirebaseApp.configure()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let rootVC: UIViewController
        if storage.isLoginExist() && storage.isPhoneExist() {
            rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomController")
        } else {
            rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController")
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = rootVC
        self.window!.makeKeyAndVisible()
        
        return true
    }
}

