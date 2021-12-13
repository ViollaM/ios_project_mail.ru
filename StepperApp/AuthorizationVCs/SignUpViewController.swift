//
//  SignUpViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 30.10.2021.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var signupButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = StepColor.authButton
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.setTitle("Create an account", for: .normal)
        button.setTitleColor(StepColor.darkGreen, for: .normal)
        button.addTarget(self, action: #selector(signupButtonToApp), for: .touchUpInside)
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
    
    private let nameLeftViewLabel: UILabel = {
        let label = UILabel()
        label.text = " @"
        label.font = UIFont(name: "Arial", size: 20)
        label.textColor = StepColor.darkGreen
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let text = UITextField()
        text.layer.cornerRadius = 10
        text.placeholder = "nickname"
        text.textColor = StepColor.darkGreen
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.backgroundColor = StepColor.cellBackground
        text.tintColor = StepColor.darkGreen
        text.autocapitalizationType = .none
        text.autocorrectionType = .no
        text.leftViewMode = .always
        text.addTarget(self, action: #selector(self.changeLeftViewBegin), for: .editingDidBegin)
        text.addTarget(self, action: #selector(self.changeLeftViewEnd), for: .editingDidEnd)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackground()
    }
    
    private func setupView() {
        [emailTextField, signupButton, nameTextField, passwordTextField, ].forEach {
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
            .top(172)
            .horizontally(52)
            .height(49)
        nameTextField.pin
            .below(of: emailTextField)
            .marginTop(18)
            .horizontally(52)
            .height(49)
        passwordTextField.pin
            .below(of: nameTextField)
            .marginTop(18)
            .horizontally(52)
            .height(49)
        signupButton.pin
            .below(of: passwordTextField)
            .marginTop(32)
            .horizontally(52)
            .height(72)
    }
    
    @objc
    func changeLeftViewBegin() {
        self.nameTextField.leftView = nameLeftViewLabel
    }
    
    @objc
    func changeLeftViewEnd() {
        if nameTextField.text == "" {
            self.nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.nameTextField.frame.height))
            
        }
    }
    
    @objc func signupButtonToApp() {
        guard
            let emailText = emailTextField.text,
            let nameText = nameTextField.text,
            let passwordText = passwordTextField.text
        else {
            return
        }
        
        let responseName = Validation.shared.validate(values: (ValidationType.userName, nameText))
        let responsePassword = Validation.shared.validate(values: (ValidationType.userPassword, passwordText))
        switch responseName {
        case .success:
            switch responsePassword {
            case .success:
                authService.registrationUser(email: emailText, name: nameText, password: passwordText) { [weak self] result in
                            guard let self = self else {
                                return
                            }
                            switch result {
                            case nil:
                                let rootVC = buildAppTabBarController()
                                let navVC = UINavigationController(rootViewController: rootVC)
                                navVC.navigationBar.isHidden = true
                                navVC.modalPresentationStyle = .fullScreen
                                self.present(navVC, animated: true)
                                UserDefaults.standard.set(true, forKey: "isLogged")
                            default:
                                displayAlert(message: result!.localizedDescription, viewController: self)
                            }
                        }
            case .failure:
                displayAlert(message: "Password should be 6-15 symbols long", viewController: self)
            }
        case .failure:
                switch responsePassword {
                case .success:
                    displayAlert(message: "Name should contain from 1 to 10 lower- or uppercase letters, digits or -", viewController: self)
                case .failure:
                    displayAlert(message: "Name should contain from 1 to 10 lower- or uppercase letters, digits or -; password should be 6-15 symbols long", viewController: self)
                }
            }
}
}
