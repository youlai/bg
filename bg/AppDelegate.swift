//
//  AppDelegate.swift
//  bg
//
//  Created by Apple on 2019/12/5.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
//        window?.rootViewController=UINavigationController(rootViewController: UIWebViewViewController())
        
        return true
    }


}

