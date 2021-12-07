//
//  AuthorizationViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 30.10.2021.
//

import UIKit
import PinLayout

class AuthorizationViewController: UIViewController {
    
    private let loginVc: LoginViewController
    private let signUpVc: SignUpViewController
    
    init(loginVc: LoginViewController, signUpVc: SignUpViewController) {
        self.loginVc = loginVc
        self.signUpVc = signUpVc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to"
        label.textAlignment = .center
        label.textColor = StepColor.darkGreen8
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    private lazy var stepBeatLabel: UILabel = {
        let label = UILabel()
        label.text = "StepBeat"
        label.textAlignment = .center
        label.textColor = StepColor.darkGreen
        label.font = .systemFont(ofSize: 70, weight: .medium)
        return label
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = StepColor.alpha5
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(StepColor.darkGreen, for: .normal)
        button.addTarget(self, action: #selector(loginButtonPushed), for: .touchUpInside)
        return button
    }()
    private lazy var signupButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = StepColor.alpha5
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(StepColor.darkGreen, for: .normal)
        button.addTarget(self, action: #selector(sigunpButtosPushed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackground()
    }
    
    private func setupView() {
        [welcomeLabel, stepBeatLabel, loginButton, signupButton].forEach {
            view.addSubview($0)
        }

    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        welcomeLabel.pin
            .top(114)
            .horizontally(24)
            .height(34)
        stepBeatLabel.pin
            .below(of: welcomeLabel)
            .horizontally(25)
            .height(99)
        signupButton.pin
            .bottom(54)
            .horizontally(71)
            .height(56)
        loginButton.pin
            .above(of: signupButton)
            .marginBottom(20)
            .horizontally(71)
            .height(56)
    }
    
    private func setupBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "BG")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }

    @objc
    private func loginButtonPushed() {
        let title = "Log In"
        pushVC(loginVc, title: title)
    }
    
    @objc
    private func sigunpButtosPushed() {
        let title = "Sign Up"
        pushVC(signUpVc, title: title)
    }
    
    private func pushVC(_ vc: UIViewController, title: String) {
        navigationController?.pushViewController(vc, animated: true)
        vc.title = title
        vc.navigationController?.navigationBar.isHidden = false
        vc.navigationController?.navigationBar.prefersLargeTitles = true
        vc.navigationController?.navigationBar.tintColor = StepColor.darkGreen
        vc.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: StepColor.darkGreen]
    }

}
