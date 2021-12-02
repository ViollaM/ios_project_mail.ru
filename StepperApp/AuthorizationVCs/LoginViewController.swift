//
//  LoginViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 30.10.2021.
//

import UIKit
import PinLayout

final class LoginViewController: UIViewController {
    
    private let authService = AuthServiceImplementation()

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = StepColor.authButton
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(StepColor.darkGreen, for: .normal)
        button.addTarget(self, action: #selector(loginButtonToApp), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailTextField: UITextField = {
        let text = UITextField()
        text.layer.cornerRadius = 10
        text.placeholder = "e-mail"
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.backgroundColor = StepColor.cellBackground
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
        text.backgroundColor = StepColor.cellBackground
        text.autocapitalizationType = .none
        text.autocorrectionType = .no
        text.isSecureTextEntry = true
        return text
    }()
    
    private lazy var resetPasswordTLable: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString.init(string: "Reset password")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
            NSRange.init(location: 0, length: attributedString.length));
        label.attributedText = attributedString
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.isUserInteractionEnabled = true
        
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resetPasswordToApp))
        label.addGestureRecognizer(guestureRecognizer)
        label.translatesAutoresizingMaskIntoConstraints = false

        //text.backgroundColor = StepColor.cellBackground
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackground()
    }
    
    private func setupView() {
        [loginButton, emailTextField, passwordTextField, resetPasswordTLable].forEach {
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
        
        emailTextField.pin
            .top(159)
            .horizontally(52)
            .height(49)
        passwordTextField.pin
            .below(of: emailTextField)
            .marginTop(18)
            .horizontally(52)
            .height(49)
        loginButton.pin
            .below(of: passwordTextField)
            .marginTop(32)
            .horizontally(52)
            .height(72)
        resetPasswordTLable.pin
            .below(of: loginButton)
            .marginTop(16)
            .horizontally(52)
            .height(30)
    }
    
    @objc func resetPasswordToApp(sender: UITapGestureRecognizer) {
        authService.resetPassword(email: emailTextField.text!) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case nil:
                print("Отправили письмо о смене пароля")
            default :
                print(result!.localizedDescription)
            }
        }
    }
    
    @objc func loginButtonToApp() {
        guard
            let _ = emailTextField.text,
            let _ = passwordTextField.text
        else {
            return
        }
        
        authService.loginUser(email: emailTextField.text!, password: passwordTextField.text!){ [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case nil:
                UserDefaults.standard.set(true, forKey: "isLogged")
                let rootVC = buildAppTabBarController()
                let navVC = UINavigationController(rootViewController: rootVC)
                navVC.navigationBar.isHidden = true
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            default :
                print(result!.localizedDescription)
            }
        }
        
        
//        UserDefaults.standard.set(true, forKey: "isLogged")
//        let rootVC = buildAppTabBarController()
//        let navVC = UINavigationController(rootViewController: rootVC)
//        navVC.navigationBar.isHidden = true
//        navVC.modalPresentationStyle = .fullScreen
//        present(navVC, animated: true)
    }
    
}

