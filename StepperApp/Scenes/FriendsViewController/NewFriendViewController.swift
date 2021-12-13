//
//  NewFriendViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.12.2021.
//

import UIKit
import PanModal

protocol NewFriendDelegate: AnyObject {
    func searchForUser(nickname: String)
}

final class NewFriendViewController: UIViewController {
    weak var delegate: NewFriendDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = StepColor.darkGreen
        label.text = "Add friend"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    private lazy var newFriendTextField: UITextField = {
        let text = UITextField()
        text.layer.cornerRadius = 10
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.backgroundColor = StepColor.tabBarBackground
        text.autocapitalizationType = .none
        text.autocorrectionType = .no
        text.placeholder = "Enter the nickname"
        text.tintColor = StepColor.darkGreen
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var addButton: RoundButton = {
        let button = RoundButton()
        button.layer.cornerRadius = 10
        button.setTitleColor(StepColor.cellBackground, for: .normal)
        button.backgroundColor = StepColor.buttonBackground
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(addButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .close)
        button.tintColor = StepColor.darkGreen
        button.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 10
        view.backgroundColor = StepColor.background
        setupLayout()
        
    }
    
    private func setupLayout() {
        [titleLabel, newFriendTextField, cancelButton, addButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            newFriendTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            newFriendTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            newFriendTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            newFriendTextField.heightAnchor.constraint(equalToConstant: 42),
            
            addButton.topAnchor.constraint(equalTo: newFriendTextField.bottomAnchor, constant: 12),
            addButton.leadingAnchor.constraint(equalTo: newFriendTextField.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: newFriendTextField.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            cancelButton.heightAnchor.constraint(equalToConstant: 25),
            cancelButton.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    @objc
    private func addButtonTap() {
        let nickname = newFriendTextField.text ?? ""
        delegate?.searchForUser(nickname: nickname)
        newFriendTextField.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func closeButtonTap() {
        dismiss(animated: true, completion: nil)
    }
}
