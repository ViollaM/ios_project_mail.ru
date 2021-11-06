//
//  FriendsListViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit

final class FriendsListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }

    func setupNavigationItem () {
        self.title = "Friends"
    }

}
