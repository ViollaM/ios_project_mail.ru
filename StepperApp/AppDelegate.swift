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
        let isAuth: Bool = UserDefaults.standard.bool(forKey: "isLogged")
        var rootVC = UIViewController()
        if isAuth {
            rootVC = buildAppTabBarController()
        }
        else {
            rootVC = AuthorizationViewController()
        }
        let rootNC = UINavigationController(rootViewController: rootVC)
        rootNC.navigationBar.isHidden = true
        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
        return true
    }
}

