//
//  EachCompetitionViewController.swift
//  StepperApp
//
//  Created by Маргарита Яковлева on 16.11.2021.
//

import UIKit
import PinLayout

final class EachCompetitionViewController: UIViewController {
    
    var timer = Timer()
    
    var competition: competitionData? {
        didSet {
            competitionLeaderLabel.text = "Leader: \(competition?.currentLeader ?? "unknown")"
            competitionTitleLabel.text = competition?.name
            descriptionLabel.text = competition?.text
            remainingTimeLabel.text = currentTime()
            progressLabel.text = "\(Int((competition?.currentValue)!)) / \(Int((competition?.maxValue)!))"
        }
    }
    
    private lazy var competitionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var competitionLeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()
    
    
    private lazy var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var timeEndsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22)
        label.text = "The competition ends in: "
        return label
    }()
    
    private lazy var yourProgressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22)
        label.text = "Your progress: "
        return label
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 46, weight: .bold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = StepColor.cellBackground
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc
    private func updateTimeLabel() {
        remainingTimeLabel.text = currentTime()
    }
    
    private func setupLayout() {
        [competitionTitleLabel, descriptionLabel, remainingTimeLabel, timeEndsLabel, yourProgressLabel, progressLabel].forEach {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            competitionTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            competitionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 11),
            competitionTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            competitionTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            descriptionLabel.topAnchor.constraint(equalTo: competitionTitleLabel.bottomAnchor, constant: 25),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 11),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            timeEndsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 33),
            timeEndsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 11),
            timeEndsLabel.widthAnchor.constraint(equalToConstant: 244),
            timeEndsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            remainingTimeLabel.topAnchor.constraint(equalTo: timeEndsLabel.bottomAnchor, constant: 20),
            remainingTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 11),
            remainingTimeLabel.widthAnchor.constraint(equalToConstant: 130),
            remainingTimeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            yourProgressLabel.topAnchor.constraint(equalTo: remainingTimeLabel.bottomAnchor, constant: 25),
            yourProgressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 11),
            yourProgressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            yourProgressLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            progressLabel.topAnchor.constraint(equalTo: yourProgressLabel.bottomAnchor, constant: 25),
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 11),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1)
        ])
    }
}
