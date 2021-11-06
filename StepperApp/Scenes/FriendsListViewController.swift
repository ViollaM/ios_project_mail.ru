//
//  FriendsListViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit

final class FriendsListViewController: UIViewController {

    private lazy var toAuthorizationButton: UIButton = {
        let button = UIButton()
        button.setTitle("To authorization", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 46/255, green: 85/255, blue: 82/255, alpha: 1)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(toAuthorization), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupLayout()
    }

    func setupNavigationItem () {
        self.title = "Friends"
    }
    
    func setupLayout () {
        view.addSubview(toAuthorizationButton)
    }
    
    @objc func toAuthorization() {
        let rootVC = AuthorizationViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        toAuthorizationButton.pin
            .bottom(150)
            .horizontally(24)
            .height(56)
    }
}
