//
//  TabBarControllerFunc.swift
//  StepperApp
//
//  Created by Ruben Egikian on 30.10.2021.
//

import UIKit

func buildAppTabBarController() -> UITabBarController {
    let tabBarController = UITabBarController()
    let stepsService = StepsServiceImplementation()
    let profileService = ProfileServiceImplementation()
    let viewcontollers = [buildStepsViewController(stepsService: stepsService), buildFriendsListViewController(), buildCompetitionViewController(),  buildProfileViewController(profileService: profileService)]
    viewcontollers.forEach {
        setupBackground(on: $0)
    }
    tabBarController.setViewControllers(viewcontollers, animated: true)
    tabBarController.tabBar.isTranslucent = false
    tabBarController.selectedIndex = 0
    tabBarController.tabBar.unselectedItemTintColor = StepColor.unselected
    tabBarController.tabBar.tintColor = StepColor.darkGreen
    tabBarController.tabBar.backgroundColor = StepColor.tabBarBackground
    tabBarController.tabBar.backgroundImage = UIImage()
    tabBarController.tabBar.shadowImage = UIImage()
    tabBarController.tabBar.isTranslucent = true
    return tabBarController
}

func buildStepsViewController(stepsService: StepsService) -> UIViewController {
    let navigationController = UINavigationController()
    let viewController = StepsViewController(stepsService: stepsService)
    navigationController.viewControllers = [viewController]
    let stepsItem = UITabBarItem(title: "Steps", image: UIImage(systemName: "figure.walk"), selectedImage: nil)
    viewController.tabBarItem = stepsItem
    return navigationController
}

func buildProfileViewController(profileService: ProfileService) -> UIViewController {
    let navigationController = UINavigationController()
    let viewController = ProfileViewController(profileService: profileService)
    navigationController.viewControllers = [viewController]
    navigationController.navigationBar.prefersLargeTitles = true
    navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: StepColor.darkGreen]
    navigationController.navigationBar.isHidden = false
    let profileItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: nil)
    viewController.tabBarItem = profileItem
    viewController.title = "Profile"
    return navigationController
}

func buildFriendsListViewController() -> UIViewController {
    let navigationController = UINavigationController()
    let viewController = FriendsListViewController()
    navigationController.viewControllers = [viewController]
    navigationController.navigationBar.prefersLargeTitles = true
    navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: StepColor.darkGreen]
    navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController.navigationBar.shadowImage = UIImage()
    navigationController.navigationBar.isTranslucent = true
    navigationController.navigationBar.isHidden = false
    let friendsListItem = UITabBarItem(title: "Friends", image: UIImage(systemName: "person.3"), selectedImage: nil)
    viewController.tabBarItem = friendsListItem
    viewController.title = "Friends"
    return navigationController
}

func buildCompetitionViewController() -> UIViewController {
    let navigationController = UINavigationController()
    let viewController = CompetitionViewController()
    navigationController.viewControllers = [viewController]
    navigationController.navigationBar.prefersLargeTitles = true
    navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: StepColor.darkGreen]
    navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController.navigationBar.shadowImage = UIImage()
    navigationController.navigationBar.isTranslucent = true
    navigationController.navigationBar.isHidden = false
    let challengeItem = UITabBarItem(title: "Competition", image: UIImage(systemName: "crown"), selectedImage: nil)
    viewController.tabBarItem = challengeItem
    viewController.title = "Competition"
    return navigationController
}

func setupBackground(on viewcontroller: UIViewController) {
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    backgroundImage.image = UIImage(named: "BG")
    backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
    viewcontroller.view.insertSubview(backgroundImage, at: 0)
}
