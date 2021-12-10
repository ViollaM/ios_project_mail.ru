//
//  SettingsUnitMeasureCell.swift
//  StepperApp
//
//  Created by Ruben Egikian on 06.12.2021.
//

import UIKit

final class SettingsUnitMeasureCell: UICollectionViewCell {
    lazy var unitSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["km", "miles"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentTintColor = StepColor.darkGreen8
        sc.selectedSegmentIndex = 0
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: StepColor.cellBackground], for: .selected)
        sc.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return sc
    }()
    
    @objc
    private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: kmSelected()
        case 1: milesSelected()
        default:
            break
        }
    }
    
    private func kmSelected() {
        print("steps")
    }
    
    private func milesSelected() {
        print("distance")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(unitSegmentedControl)
        NSLayoutConstraint.activate([
            unitSegmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor),
            unitSegmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            unitSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            unitSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
