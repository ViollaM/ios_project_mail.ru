//
//  AppDelegate.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let rootVC = AuthorizationViewController()
        let rootNC = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
        return true
    }
}

