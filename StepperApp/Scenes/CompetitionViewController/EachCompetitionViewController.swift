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
    
    var competition: CompetitionData? {
        didSet {
            if let competition = competition {
                competitionLeaderLabel.text = "Leader: \(competition.currentLeader ?? "@user")"
                competitionTitleLabel.text = competition.name
                descriptionLabel.text = competition.text
                remainingTimeLabel.text = currentTime()
                if competition.isStepsCompetition {
                    progressLabel.text = "\(Int(competition.currentValue)) / \(Int(competition.maxValue))"
                } else {
                    let roundedDistance = String(format: "%.1f", competition.currentValue)
                    progressLabel.text = roundedDistance + " / \(competition.maxValue)"
                }
                
                progressBar.progress  = Float((competition.currentValue) / (competition.maxValue))
                if competition.isFinished {
                    print("Progress is over 1")
                    progressBar.isHidden = true
                    wellDoneLabel.isHidden = false
                }
            }
        }
    }
    
    private lazy var competitionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 0
        label.textColor = StepColor.darkGreen
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
        label.font = .systemFont(ofSize: 20)
        label.textColor = StepColor.progress
        label.numberOfLines = 0
        return label
    }()
    
    
    private lazy var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = StepColor.darkGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var timeEndsLabel: UILabel = {
        let label = UILabel()
        label.textColor = StepColor.darkGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.text = "Remaining time: "
        return label
    }()
    
    private lazy var yourProgressLabel: UILabel = {
        let label = UILabel()
        label.textColor = StepColor.darkGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.text = "Your progress: "
        return label
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = StepColor.darkGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    lazy var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.tintColor = StepColor.progress
        bar.trackTintColor = StepColor.cellBackground
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.clipsToBounds = true
        return bar
    }()
    
    private lazy var wellDoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = StepColor.darkGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 0
        label.text = "Well done!"
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var otherParticipantsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.textColor = StepColor.progress
        label.numberOfLines = 0
        label.text = "Other participants:"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = StepColor.background
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        
        progressBar.subviews.forEach { subview in
            subview.layer.masksToBounds = true
            subview.layer.cornerRadius = 10
        }
    }
    
    @objc
    private func updateTimeLabel() {
        remainingTimeLabel.text = currentTime()
    }
    
    private func setupLayout() {
        [competitionTitleLabel, descriptionLabel, remainingTimeLabel, timeEndsLabel, yourProgressLabel, progressLabel, progressBar, wellDoneLabel, otherParticipantsLabel].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            competitionTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            competitionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            competitionTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            competitionTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            descriptionLabel.topAnchor.constraint(equalTo: competitionTitleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: competitionTitleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: competitionTitleLabel.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            timeEndsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 14),
            timeEndsLabel.leadingAnchor.constraint(equalTo: competitionTitleLabel.leadingAnchor),
            timeEndsLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            timeEndsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            remainingTimeLabel.centerYAnchor.constraint(equalTo: timeEndsLabel.centerYAnchor),
            remainingTimeLabel.trailingAnchor.constraint(equalTo: competitionTitleLabel.trailingAnchor),
            remainingTimeLabel.leadingAnchor.constraint(equalTo: timeEndsLabel.trailingAnchor, constant: 12),
            remainingTimeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            yourProgressLabel.topAnchor.constraint(equalTo: timeEndsLabel.bottomAnchor, constant: 6),
            yourProgressLabel.leadingAnchor.constraint(equalTo: competitionTitleLabel.leadingAnchor),
            yourProgressLabel.widthAnchor.constraint(equalTo: timeEndsLabel.widthAnchor),
            yourProgressLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            progressLabel.centerYAnchor.constraint(equalTo: yourProgressLabel.centerYAnchor),
            progressLabel.trailingAnchor.constraint(equalTo: competitionTitleLabel.trailingAnchor),
            progressLabel.leadingAnchor.constraint(equalTo: yourProgressLabel.trailingAnchor, constant: 12),
            progressLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            progressBar.topAnchor.constraint(equalTo: yourProgressLabel.bottomAnchor, constant: 14),
            progressBar.leadingAnchor.constraint(equalTo: competitionTitleLabel.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: competitionTitleLabel.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 25),
            
            wellDoneLabel.topAnchor.constraint(equalTo: yourProgressLabel.bottomAnchor, constant: 14),
            wellDoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wellDoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wellDoneLabel.heightAnchor.constraint(equalToConstant: 30),
            
            otherParticipantsLabel.topAnchor.constraint(equalTo: yourProgressLabel.bottomAnchor, constant: 74),
            otherParticipantsLabel.leadingAnchor.constraint(equalTo: competitionTitleLabel.leadingAnchor),
            otherParticipantsLabel.trailingAnchor.constraint(equalTo: competitionTitleLabel.trailingAnchor),
            otherParticipantsLabel.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
}
