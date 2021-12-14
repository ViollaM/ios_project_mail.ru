//
//  LoginViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 30.10.2021.
//

import UIKit
import PinLayout

final class LoginViewController: UIViewController {
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
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
        text.textColor = StepColor.darkGreen
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.backgroundColor = StepColor.cellBackground
        text.tintColor = StepColor.darkGreen
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
        text.tintColor = StepColor.darkGreen
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
        label.textColor = StepColor.darkGreen
        label.isUserInteractionEnabled = true
        
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resetPasswordToApp))
        label.addGestureRecognizer(guestureRecognizer)
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        view.backgroundColor = StepColor.background
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
            guard self != nil else {
                return
            }
            switch result {
            case nil:
                displayAlert(message: "We have sent you an email to recover your password", viewController: self ?? UIViewController())
            default :
                displayAlert(message: result!.localizedDescription, viewController: self ?? UIViewController())
            }
        }
    }
    
    @objc func loginButtonToApp() {
        guard
            let emailText = emailTextField.text,
            let passwordText = passwordTextField.text
        else {
            return
        }
        
        authService.loginUser(email: emailText, password: passwordText){ [weak self] result in
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
                displayAlert(message: result!.localizedDescription, viewController: self)
            }
        }
    }
}
