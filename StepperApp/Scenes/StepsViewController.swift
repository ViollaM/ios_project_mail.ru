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
        let stack = UIStackView(arrangedSubviews: [stepsLabel, distanceLabel, stepsLeftLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 45, leading: 0, bottom: 20, trailing: 0)
        stack.spacing = 10
        stack.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.47)
        return stack
    }()
    
    private lazy var stepsLabel: UILabel = {
        let label = UILabel()
        label.text = "7509"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        return label
    }()
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "distance: 6.0km"
        return label
    }()
    private lazy var stepsLeftLabel: UILabel = {
        let label = UILabel()
        label.text = "left: 2131"
        return label
    }()
    
    private lazy var weekChartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Week", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.47)
        button.addTarget(self, action: #selector(weekButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    func setupLayout () {
        view.addSubview(stackView)
        view.addSubview(weekChartButton)
        stackView.pin
            .top(80)
            .height(200)
            .width(200)
            .hCenter()
        
        weekChartButton.pin
            .bottom(100)
            .horizontally(100)
            .height(40)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        stackView.layer.cornerRadius = stackView.frame.width/2
        weekChartButton.layer.cornerRadius = 10
    }
    
    private func setupBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "BG")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    @objc func weekButtonPressed () {
        let vc = WeekChartViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
