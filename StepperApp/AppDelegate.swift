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
        window?.rootViewController = buildAppTabBarController()
        window?.makeKeyAndVisible()
        return true
    }
    
    func buildAppTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([buildStepsViewController(), buildProfileViewController(), buildChallengeViewController(), buildFriendsListViewController()], animated: true)
        tabBarController.selectedIndex = 0
        tabBarController.tabBar.tintColor = .black
        return tabBarController
    }
 
    func buildStepsViewController() -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.view.backgroundColor = .systemBackground
        
        let viewController = StepsViewController()
        navigationController.viewControllers = [viewController]
        let stepsItem = UITabBarItem(title: "Steps", image: UIImage(systemName: "figure.walk"), selectedImage: nil)
        viewController.tabBarItem = stepsItem
        return navigationController
    }
    
    func buildProfileViewController() -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.view.backgroundColor = .systemBackground
        
        let viewController = ProfileViewController()
        navigationController.viewControllers = [viewController]
        let profileItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: nil)
        viewController.tabBarItem = profileItem
        return navigationController
    }
    
    func buildFriendsListViewController() -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.view.backgroundColor = .systemBackground
        
        let viewController = FriendsListViewController()
        navigationController.viewControllers = [viewController]
        let friendsListItem = UITabBarItem(title: "Friends", image: UIImage(systemName: "person.3"), selectedImage: nil)
        viewController.tabBarItem = friendsListItem
        return navigationController
    }
    
    func buildChallengeViewController() -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.view.backgroundColor = .systemBackground
        
        let viewController = ChallengeViewController()
        navigationController.viewControllers = [viewController]
        let challengeItem = UITabBarItem(title: "Challenge", image: UIImage(systemName: "gamecontroller"), selectedImage: nil)
        viewController.tabBarItem = challengeItem
        return navigationController
    }
    

}

