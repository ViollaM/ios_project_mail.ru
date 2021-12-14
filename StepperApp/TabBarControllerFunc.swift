//
//  TabBarControllerFunc.swift
//  StepperApp
//
//  Created by Ruben Egikian on 30.10.2021.
//

import UIKit

func buildAppTabBarController() -> UITabBarController {
    let tabBarController = UITabBarController()
    let pedometerService = PedometerServiceImplementation()
    let stepsService = StepsServiceImplementation()
    let profileService = ProfileServiceImplementation()
    let usersService = UsersServiceImplementation()
    let friendsService = FriendsServiceImplementation()
    let imageLoaderService = ImageLoaderServiceImplementation()
    let viewcontollers = [buildStepsViewController(stepsService: stepsService, pedometerService: pedometerService), buildFriendsListViewController(friendsService: friendsService, imageLoaderService: imageLoaderService), buildCompetitionViewController(stepsService: stepsService, pedometerService: pedometerService),  buildProfileViewController(profileService: profileService, usersService: usersService, imageService: imageLoaderService)]
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

func buildStepsViewController(stepsService: StepsService, pedometerService: PedometerService) -> UIViewController {
    let navigationController = UINavigationController()
    let viewController = StepsViewController(stepsService: stepsService, pedometerService: pedometerService)
    navigationController.viewControllers = [viewController]
    navigationController.navigationBar.tintColor = StepColor.darkGreen
    let stepsItem = UITabBarItem(title: "Steps", image: UIImage(systemName: "figure.walk"), selectedImage: nil)
    viewController.tabBarItem = stepsItem
    return navigationController
}

func buildProfileViewController(profileService: ProfileService, usersService: UsersService, imageService: ImageLoaderService) -> UIViewController {
    let navigationController = UINavigationController()
    let viewController = ProfileViewController(profileService: profileService, usersService: usersService, imageLoaderService: imageService)
    navigationController.viewControllers = [viewController]
    navigationController.navigationBar.prefersLargeTitles = true
    navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: StepColor.darkGreen]
    navigationController.navigationBar.isHidden = false
    let profileItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: nil)
    viewController.tabBarItem = profileItem
    viewController.title = "Profile"
    return navigationController
}

func buildFriendsListViewController(friendsService: FriendsService, imageLoaderService: ImageLoaderService) -> UIViewController {
    let navigationController = UINavigationController()
    let viewController = FriendsListViewController(friendsService: friendsService, imageLoaderService: imageLoaderService)
    navigationController.viewControllers = [viewController]
    navigationController.navigationBar.prefersLargeTitles = true
    navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: StepColor.darkGreen]
    navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController.navigationBar.shadowImage = UIImage()
    navigationController.navigationBar.isTranslucent = true
    navigationController.navigationBar.isHidden = false
    let friendsListItem = UITabBarItem(title: "Subscriptions", image: UIImage(systemName: "person.3"), selectedImage: nil)
    viewController.tabBarItem = friendsListItem
    viewController.title = "Subscriptions"
    return navigationController
}

func buildCompetitionViewController(stepsService: StepsService, pedometerService: PedometerService) -> UIViewController {
    let navigationController = UINavigationController()
    let viewController = CompetitionViewController(stepsService: stepsService, pedometerService: pedometerService)
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
