//
//  SettingsDailyGoalCell.swift
//  StepperApp
//
//  Created by Ruben Egikian on 06.12.2021.
//

import UIKit

protocol DailyGoalDelegate {
    func newGoalIs(goal: Double)
}

final class SettingsDailyGoalCell: UICollectionViewCell {
    var delegate: DailyGoalDelegate?
    
    lazy var stepsOrDistanceSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Steps", "Distance"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentTintColor = StepColor.darkGreen8
        sc.selectedSegmentIndex = 0
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: StepColor.cellBackground], for: .selected)
        sc.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return sc
    }()
    
    private lazy var goalCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = goalStepsCount.formattedWithSeparator
        label.textColor = StepColor.darkGreen
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let trianglePath = UIBezierPath()
        let triangleLayer = CAShapeLayer()
        trianglePath.move(to: CGPoint(x: 0, y: 0))
        trianglePath.addLine(to: CGPoint(x: 37, y: 16))
        trianglePath.addLine(to: CGPoint(x: 0, y: 32))
        trianglePath.addLine(to: CGPoint(x: 0, y: 0))
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = StepColor.cellBackground.cgColor
        button.layer.addSublayer(triangleLayer)
        button.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let trianglePath = UIBezierPath()
        let triangleLayer = CAShapeLayer()
        trianglePath.move(to: CGPoint(x: 37, y: 0))
        trianglePath.addLine(to: CGPoint(x: 0, y: 16))
        trianglePath.addLine(to: CGPoint(x: 37, y: 32))
        trianglePath.addLine(to: CGPoint(x: 37, y: 0))
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = StepColor.cellBackground.cgColor
        button.layer.addSublayer(triangleLayer)
        button.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var goalStepsCount = 10000
    private var goalDistanceCount: Double = 10
    
    @objc
    private func minusButtonPressed() {
        if stepsOrDistanceSegmentedControl.selectedSegmentIndex == 0 && goalStepsCount > 0 {
            goalStepsCount -= 500
            goalCountLabel.text = goalStepsCount.formattedWithSeparator
            delegate?.newGoalIs(goal: Double(goalStepsCount))
        } else if stepsOrDistanceSegmentedControl.selectedSegmentIndex == 1 && goalDistanceCount > 0 {
            goalDistanceCount -= 0.5
            goalCountLabel.text = goalDistanceCount.formattedWithSeparator
            delegate?.newGoalIs(goal: goalDistanceCount)
        }
    }
    
    @objc
    private func plusButtonPressed() {
        if stepsOrDistanceSegmentedControl.selectedSegmentIndex == 0 {
            goalStepsCount += 500
            goalCountLabel.text = goalStepsCount.formattedWithSeparator
        } else {
            goalDistanceCount += 0.5
            goalCountLabel.text = goalDistanceCount.formattedWithSeparator
        }
    }
    
    @objc
    private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: goalCountLabel.text = goalStepsCount.formattedWithSeparator
        case 1: goalCountLabel.text = goalDistanceCount.formattedWithSeparator
        default:
            break
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsDailyGoalCell {
    private func setupViews() {
        [stepsOrDistanceSegmentedControl, goalCountLabel, plusButton, minusButton].forEach {
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            stepsOrDistanceSegmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor),
            stepsOrDistanceSegmentedControl.heightAnchor.constraint(equalToConstant: 22),
            stepsOrDistanceSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stepsOrDistanceSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            goalCountLabel.topAnchor.constraint(equalTo: stepsOrDistanceSegmentedControl.bottomAnchor, constant: 12),
            goalCountLabel.centerXAnchor.constraint(equalTo: stepsOrDistanceSegmentedControl.centerXAnchor),
            goalCountLabel.widthAnchor.constraint(equalToConstant: 130),
            goalCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            plusButton.centerYAnchor.constraint(equalTo: goalCountLabel.centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: goalCountLabel.trailingAnchor, constant: 12),
            plusButton.widthAnchor.constraint(equalToConstant: 37),
            plusButton.heightAnchor.constraint(equalToConstant: 32),
            
            minusButton.centerYAnchor.constraint(equalTo: goalCountLabel.centerYAnchor),
            minusButton.trailingAnchor.constraint(equalTo: goalCountLabel.leadingAnchor, constant: -12),
            minusButton.widthAnchor.constraint(equalToConstant: 37),
            minusButton.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
}
