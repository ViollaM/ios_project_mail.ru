//
//  ViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit
import PinLayout

class StepsViewController: UIViewController {

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label1, label2, label3])
        stack.axis = .vertical
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 45, leading: 0, bottom: 20, trailing: 0)
        stack.spacing = 10
        stack.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.47)
        return stack
    }()
    
    private lazy var label1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "7509"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        return label
    }()
    private lazy var label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "distance: 6.0km"
        return label
    }()
    private lazy var label3: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "left: 2131"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupBackground()
        setupLayout()
    }

    func setupLayout () {
        view.addSubview(stackView)
        stackView.pin
            .top(80)
            .height(200)
            .width(200)
            .left(87)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        stackView.layer.cornerRadius = stackView.frame.width/2
    }
    
    private func setupBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "BG")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
}
