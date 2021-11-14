//
//  ChallengeViewCell.swift
//  StepperApp
//
//  Created by Маргарита Яковлева on 06.11.2021.
//

import Foundation
import UIKit
import PinLayout

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

struct competitionData {
    var name: String?
    var maxValue = 10000.0
    var currentValue = 0.0
    var remainingTime: String?
    var currentLeader: String?
    
    init(name: String, maxValue: Double, currentValue: Double, remainingTime: String, currentLeader: String)
        {
            self.name = name
            self.maxValue = maxValue
            self.currentValue = currentValue
            self.remainingTime = remainingTime
            self.currentLeader = currentLeader
        }
}

struct timeData {
    var hour = 0
    var minute = 0
    var second = 0
    var time: String = "00:00:00"
    
    init(hour: Int, minute: Int, second: Int, time: String)
        {
            self.hour = hour
            self.minute = minute
            self.second = second
            self.time = time
        }
}

var date = Date()
var calendar = Calendar.current
var hour = calendar.component(.hour, from: date)
var minute = calendar.component(.minute, from: date)
var second = calendar.component(.second, from: date)
//    let time = String(hour) + " h " + String(minute) + " min " + String(second) + " sec "
var time = String(hour) + ":" + String(minute) + ":" + String(second)

class CompetitionViewCell: UICollectionViewCell {
    
    var timer = Timer()
    
    var currentTime = timeData(hour: hour, minute: minute, second: second, time: time)
    
    private lazy var competitionTitleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.numberOfLines = 2
        title.text = "Daily step competition"
        return title
    }()
    
    var competitionTimeLabel: UILabel = {
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
        bar.tintColor = UIColor(rgb: 0x0C2624)
        bar.trackTintColor = UIColor(rgb: 0xA3D2CC)
        bar.progress = 7509 / 10000
        //bar.transform = bar.transform.scaledBy(x: 1, y: 5)
        //bar.layer.cornerRadius = 50
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.clipsToBounds = true
        return bar
    }()
    
    private lazy var isComplete: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "rosette")
        image.tintColor = UIColor(rgb: 0x0C2624)
        image.backgroundColor = .clear
        return image
    }()
    
    /*override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellLayer()
        layoutSubviews()
        //configureUI()
    }
    
    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupEl()
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configureUI() {
        /*if (progressBar.progress < 1.0) {
            isComplete.tintColor = .clear
        }*/
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true);
        
        //contentView.addSubview(competitionTitleLabel)
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
        
        
        
        
//        competitionTitleLabel.pin
//            .left(10)
//            .top(6)
//            .width(120)
//            .height(50)
//
//        isComplete.pin
//            .right(6)
//            .top(8)
//            .width(25)
//            .height(28)
//
//        competitionTimeLabel.pin
//            .left(10)
//            .below(of: competitionTitleLabel).marginTop(8)
//            .width(100)
//            .height(18)
//
//        competitionLeaderLabel.pin
//            .left(10)
//            .bottom(13)
//            .width(60)
//            .height(19)
//
//        progressBar.pin
//            .left(10)
//            .below(of: competitionTimeLabel).marginTop(13)
//            .width(135)
//
//        //progressBar.heightAnchor.constraint(equalToConstant: 25).isActive = true
//
//        competitionCurrentLeaderLabel.pin
//            .right(of: competitionLeaderLabel).marginLeft(10)
//            .bottom(13)
//            .width(80)
//            .height(19)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //progressBar.layer.cornerRadius = 10
        progressBar.subviews.forEach { subview in
            subview.layer.masksToBounds = true
            subview.layer.cornerRadius = 10
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true);
    }
    
    @objc func updateTimeLabel() {
        date = Date()
        calendar = Calendar.current
        hour = calendar.component(.hour, from: date)
        minute = calendar.component(.minute, from: date)
        second = calendar.component(.second, from: date)
        time = "\(hour)" + ":" + "\(minute)" + ":" + "\(second)"
        currentTime = timeData(hour: hour, minute: minute, second: second, time: time)
        //self.title = time
    }
    
    func setupCellLayer() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UIColor(rgb: 0xCCE4E1)
    }
    
    func configure(with comp: competitionData) {
        competitionTitleLabel.text = comp.name
        competitionTimeLabel.text = comp.remainingTime
        competitionCurrentLeaderLabel.text = comp.currentLeader
        progressBar.progress = Float(comp.currentValue / comp.maxValue)
        if (progressBar.progress < 1.0) {
            isComplete.tintColor = .clear
        }
    }
    
    func timeConfigure(with time: timeData) {
        //competitionTitleLabel.text = time.name
        competitionTimeLabel.text = time.time
        /*competitionCurrentLeaderLabel.text = time.currentLeader
        progressBar.progress = Float(time.currentValue / time.maxValue)
        if (progressBar.progress < 1.0) {
            isComplete.tintColor = .clear
        }*/
    }
}
