//
//  ChallengeViewCell.swift
//  StepperApp
//
//  Created by Маргарита Яковлева on 06.11.2021.
//

import Foundation
import UIKit
import PinLayout

var date = Date()
let calendar = Calendar.current
var hour = calendar.component(.hour, from: date)
var minute = calendar.component(.minute, from: date)
let second = calendar.component(.second, from: date)
var time = currentTime()

final class CompetitionViewCell: UICollectionViewCell {
    
    var competition: competitionData? {
        didSet {
            competitionTitleLabel.text = competition?.name
            competitionTimeLabel.text = currentTime()
            competitionCurrentLeaderLabel.text = competition?.currentLeader
            progressBar.progress = Float((competition?.currentValue)! / (competition?.maxValue)!)
            if (!competition!.isFinished) {
                isComplete.isHidden = true
            } else {
                isComplete.isHidden = false
            }
        }
    }
    
    private lazy var competitionTitleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.numberOfLines = 2
        title.text = "Daily step competition"
        return title
    }()
    
    private lazy var competitionTimeLabel: UILabel = {
        let time = UILabel()
        time.translatesAutoresizingMaskIntoConstraints = false
        time.font = .systemFont(ofSize: 16)
        time.text = "9 h 37 min"
        return time
    }()

    private lazy var competitionLeaderLabel: UILabel = {
        let leader = UILabel()
        leader.translatesAutoresizingMaskIntoConstraints = false
        leader.font = .systemFont(ofSize: 16, weight: .bold)
        leader.text = "Leader: "
        return leader
    }()
    
    private lazy var competitionCurrentLeaderLabel: UILabel = {
        let current = UILabel()
        current.translatesAutoresizingMaskIntoConstraints = false
        current.font = .systemFont(ofSize: 16)
        current.text = "@max"
        return current
    }()
    
    private lazy var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.tintColor = HexColor(rgb: 0x0C2624)
        bar.trackTintColor = HexColor(rgb: 0xA3D2CC)
        bar.progress = 7509 / 10000
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.clipsToBounds = true
        return bar
    }()
    
    private lazy var isComplete: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "rosette")
        image.tintColor = HexColor(rgb: 0x0C2624)
        image.backgroundColor = .clear
        image.isHidden = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellLayer()
        layoutSubviews()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [competitionTitleLabel, competitionTimeLabel, competitionLeaderLabel, competitionCurrentLeaderLabel, progressBar, isComplete].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            competitionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            competitionTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            competitionTitleLabel.widthAnchor.constraint(equalToConstant: 120),
            competitionTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            isComplete.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            isComplete.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            isComplete.widthAnchor.constraint(equalToConstant: 25),
            isComplete.heightAnchor.constraint(equalToConstant: 28),
            
            competitionTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            competitionTimeLabel.topAnchor.constraint(equalTo: competitionTitleLabel.bottomAnchor, constant: 8),
            competitionTimeLabel.widthAnchor.constraint(equalToConstant: 100),
            competitionTimeLabel.heightAnchor.constraint(equalToConstant: 18),
            
            competitionLeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            competitionLeaderLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            competitionLeaderLabel.widthAnchor.constraint(equalToConstant: 60),
            competitionLeaderLabel.heightAnchor.constraint(equalToConstant: 19),
            
            progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            progressBar.topAnchor.constraint(equalTo: competitionTimeLabel.bottomAnchor, constant: 13),
            progressBar.widthAnchor.constraint(equalToConstant: 135),
            progressBar.heightAnchor.constraint(equalToConstant: 25),
            
            competitionCurrentLeaderLabel.leadingAnchor.constraint(equalTo: competitionLeaderLabel.trailingAnchor, constant: 10),
            competitionCurrentLeaderLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            competitionCurrentLeaderLabel.widthAnchor.constraint(equalToConstant: 80),
            competitionCurrentLeaderLabel.heightAnchor.constraint(equalToConstant: 19)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressBar.subviews.forEach { subview in
            subview.layer.masksToBounds = true
            subview.layer.cornerRadius = 10
        }
    }
    
    private func setupCellLayer() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = HexColor(rgb: 0xCCE4E1)
    }
}
