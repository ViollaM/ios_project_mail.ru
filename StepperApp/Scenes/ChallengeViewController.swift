//
//  ChallengeViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit

final class ChallengeViewController: UIViewController {

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }

    func setupNavigationItem () {
        self.title = "Challenges"
    }
}
