//
//  LoginViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 30.10.2021.
//

import UIKit
import PinLayout

final class LoginViewController: UIViewController {

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 0.59, green: 0.75, blue: 0.75, alpha: 1)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(loginButtonToApp), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameTextField: UITextField = {
        let text = UITextField()
        text.layer.cornerRadius = 10
        text.placeholder = "name"
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.backgroundColor = UIColor(red: 204/255, green: 228/255, blue: 225/255, alpha: 1)
        text.autocapitalizationType = .none
        text.autocorrectionType = .no
        return text
    }()
    
    private lazy var passwordTextField: UITextField = {
        let text = UITextField()
        text.layer.cornerRadius = 10
        text.placeholder = "password"
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.backgroundColor = UIColor(red: 204/255, green: 228/255, blue: 225/255, alpha: 1)
        text.autocapitalizationType = .none
        text.autocorrectionType = .no
        text.isSecureTextEntry = true
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBackground()
    }
    
    private func setupView() {
        title = "Log In"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor(red: 12/255, green: 38/255, blue: 36/255, alpha: 1)
        [loginButton, nameTextField, passwordTextField].forEach {
            view.addSubview($0)
        }

    }
    
    private func setupBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "BG")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        nameTextField.pin
            .top(159)
            .horizontally(52)
            .height(49)
        passwordTextField.pin
            .below(of: nameTextField)
            .marginTop(18)
            .horizontally(52)
            .height(49)
        loginButton.pin
            .below(of: passwordTextField)
            .marginTop(32)
            .horizontally(52)
            .height(72)
    }
    
    @objc func loginButtonToApp() {
        guard
            let _ = nameTextField.text,
            let _ = passwordTextField.text
        else {
            return
        }
        UserDefaults.standard.set(true, forKey: "isLogged")
        let rootVC = buildAppTabBarController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
}

