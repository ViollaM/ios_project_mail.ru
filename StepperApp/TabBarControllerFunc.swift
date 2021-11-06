//
//  TabBarControllerFunc.swift
//  StepperApp
//
//  Created by Ruben Egikian on 30.10.2021.
//

import UIKit

func buildAppTabBarController() -> UITabBarController {
    let tabBarController = UITabBarController()
    let viewcontollers = [buildStepsViewController(), buildFriendsListViewController(), buildCompetitionViewController(),  buildProfileViewController()]
    viewcontollers.forEach {
        setupBackground(on: $0)
    }
    tabBarController.setViewControllers(viewcontollers, animated: true)
    tabBarController.selectedIndex = 0
    tabBarController.tabBar.tintColor = UIColor(red: 12/255, green: 38/255, blue: 36/255, alpha: 1)
    tabBarController.tabBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
    return tabBarController
}

func buildStepsViewController() -> UIViewController {
    let navigationController = UINavigationController()
    let viewController = StepsViewController()
    navigationController.viewControllers = [viewController]
    let stepsItem = UITabBarItem(title: "Steps", image: UIImage(systemName: "figure.walk"), selectedImage: nil)
    viewController.tabBarItem = stepsItem
    return navigationController
}

func buildProfileViewController() -> UIViewController {
    let navigationController = UINavigationController()
    let viewController = FriendsListViewController()
    navigationController.viewControllers = [viewController]
    let profileItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: nil)
    viewController.tabBarItem = profileItem
    return navigationController
}

func buildFriendsListViewController() -> UIViewController {
    let navigationController = UINavigationController()
    let viewController = WeekChartViewController()
    navigationController.viewControllers = [viewController]
    let friendsListItem = UITabBarItem(title: "Friends", image: UIImage(systemName: "person.3"), selectedImage: nil)
    viewController.tabBarItem = friendsListItem
    return navigationController
}

func buildCompetitionViewController() -> UIViewController {
    let navigationController = UINavigationController()
    let viewController = CompetitionViewController()
    navigationController.viewControllers = [viewController]
    let challengeItem = UITabBarItem(title: "Competition", image: UIImage(systemName: "crown"), selectedImage: nil)
    viewController.tabBarItem = challengeItem
    return navigationController
}

func setupBackground(on viewcontroller: UIViewController) {
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    backgroundImage.image = UIImage(named: "BG")
    backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
    viewcontroller.view.insertSubview(backgroundImage, at: 0)
}
