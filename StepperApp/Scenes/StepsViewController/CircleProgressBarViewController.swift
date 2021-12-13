//
//  CircleProgressBarViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 13.12.2021.
//

import UIKit

protocol ProgressDelegate: AnyObject {
    func updateData(progress: CGFloat)
}

class CircleProgressBarViewController: UIViewController {
    private var circleBar: CircleProgressView = {
        let circle = CircleProgressView(progress: 0.01, baseColor: .gray, progressColor: .orange)
        circle.animateCircle(duration: 2, delay: 0.1)
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = .clear
    }
    
    private func setupLayout () {
        view.addSubview(circleBar)
        NSLayoutConstraint.activate([
            circleBar.topAnchor.constraint(equalTo: view.topAnchor),
            circleBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            circleBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            circleBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}

extension CircleProgressBarViewController: ProgressDelegate {
    func updateData(progress: CGFloat) {
        circleBar.progress = progress
        circleBar.layoutSubviews()
    }
}
