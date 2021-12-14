//
//  FriendsCompetitionsCell.swift
//  StepperApp
//
//  Created by Ruben Egikian on 14.12.2021.
//

import Foundation
import UIKit

final class FriendsCompetitionsCell: UICollectionViewCell {
    var competition: CompetitionData? {
        didSet {
            if let competition = competition {
                competitionTitleLabel.text = competition.name
                if !competition.isFinished {
                    isComplete.isHidden = true
                    if competition.isStepsCompetition {
                        progressLabel.text = "\(Int(competition.currentValue))"
                    } else {
                        let roundedDistance = String(format: "%.1f", competition.currentValue)
                        progressLabel.text = roundedDistance
                    }
                } else {
                    isComplete.isHidden = false
                    progressLabel.isHidden = true
                }
            }
        }
    }
    var numberOfCompetition: Int? {
        didSet {
            numberLabel.text = "\(numberOfCompetition ?? 1)."
        }
    }
    
    private lazy var competitionTitleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 18, weight: .regular)
        title.numberOfLines = 1
        title.textColor = StepColor.darkGreen
        title.textAlignment = .left
        return title
    }()
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 1
        label.textColor = StepColor.darkGreen
        return label
    }()
    private lazy var isComplete: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "rosette")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = StepColor.darkGreen
        return image
    }()
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = StepColor.darkGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .right
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupCellLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        [competitionTitleLabel, numberLabel, isComplete, progressLabel].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            numberLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 16),
            numberLabel.heightAnchor.constraint(equalToConstant: 28),

            isComplete.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            isComplete.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            isComplete.widthAnchor.constraint(equalToConstant: 24),
            isComplete.heightAnchor.constraint(equalToConstant: 28),

            progressLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            progressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            progressLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 70),
            progressLabel.heightAnchor.constraint(equalToConstant: 28),

            competitionTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            competitionTitleLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 4),
            competitionTitleLabel.trailingAnchor.constraint(equalTo: progressLabel.leadingAnchor, constant: -4),
            competitionTitleLabel.heightAnchor.constraint(equalToConstant: 28),
        ])
    }
    
    private func setupCellLayer() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = StepColor.cellBackground
    }
}
