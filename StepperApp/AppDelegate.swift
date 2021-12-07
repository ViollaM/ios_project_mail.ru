//
//  AppDelegate.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit
import IQKeyboardManager
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared().isEnabled = true
        FirebaseApp.configure()
        window = UIWindow()
        let isAuth: Bool = UserDefaults.standard.bool(forKey: "isLogged")
        var rootVC = UIViewController()
        if isAuth {
            rootVC = buildAppTabBarController()
        } else {
            let authService = AuthServiceImplementation()
            let signUpVC = SignUpViewController(authService: authService)
            let loginVc = LoginViewController(authService: authService)
            rootVC = AuthorizationViewController(loginVc: loginVc, signUpVc: signUpVC)
        }
        let rootNC = UINavigationController(rootViewController: rootVC)
        rootNC.navigationBar.isHidden = true
        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
        
        
        return true
    }
}

