//
//  HeaderCollectionReusableView.swift
//  StepperApp
//
//  Created by Ruben Egikian on 17.11.2021.
//

import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {
    
    lazy var buttonsSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["current", "finished"])
        sc.selectedSegmentTintColor = HexColor(rgb: 0x0C2624)
        sc.backgroundColor = HexColor(rgb: 0xCCE4E1)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: HexColor(rgb: 0xCCE4E1)], for: .selected)
        sc.selectedSegmentIndex = 0
        sc.isUserInteractionEnabled = true
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.layer.cornerRadius = 10
        return sc
    }()
    
    lazy var currentCompetitionButton: UIButton = {
        let button = UIButton()
        button.setTitle("current", for: .normal)
        button.setTitleColor(StepColor.darkGreen, for: .normal)
        button.backgroundColor = StepColor.cellBackground
        button.addTarget(self, action: #selector(currentCompetitionButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var finishedCompetitionButton: UIButton = {
        let button = UIButton()
        button.setTitle("finished", for: .normal)
        button.setTitleColor(StepColor.darkGreen, for: .normal)
        button.backgroundColor = StepColor.cellBackground
        button.addTarget(self, action: #selector(finishedCompetitionButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc
    private func currentCompetitionButtonPressed() {
        currentCompetitionButton.setTitleColor(StepColor.cellBackground, for: .normal)
        currentCompetitionButton.backgroundColor = StepColor.darkGreen
        finishedCompetitionButton.setTitleColor(StepColor.darkGreen, for: .normal)
        finishedCompetitionButton.backgroundColor = StepColor.cellBackground
    }
    @objc
    private func finishedCompetitionButtonPressed() {
        finishedCompetitionButton.setTitleColor(StepColor.cellBackground, for: .normal)
        finishedCompetitionButton.backgroundColor = StepColor.darkGreen
        currentCompetitionButton.setTitleColor(StepColor.darkGreen, for: .normal)
        currentCompetitionButton.backgroundColor = StepColor.cellBackground
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlusNavigationItem() {
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusButton)
    }
    
    private func setup() {
        //        addSubview(currentCompetitionButton)
        //        addSubview(finishedCompetitionButton)
        addSubview(buttonsSegmentedControl)
        //addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            //            currentCompetitionButton.topAnchor.constraint(equalTo: self.topAnchor),
            //            currentCompetitionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -19),
            //            currentCompetitionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            //            currentCompetitionButton.widthAnchor.constraint(equalToConstant: (self.frame.width - 22 * (2 + 1)) / 2),
            //
            //            finishedCompetitionButton.topAnchor.constraint(equalTo: self.topAnchor),
            //            finishedCompetitionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -19),
            //            finishedCompetitionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            //            finishedCompetitionButton.widthAnchor.constraint(equalToConstant: (self.frame.width - 22 * (2 + 1)) / 2)
            buttonsSegmentedControl.topAnchor.constraint(equalTo: self.topAnchor),
            buttonsSegmentedControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -19),
            buttonsSegmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            buttonsSegmentedControl.widthAnchor.constraint(equalToConstant: (self.frame.width - 22 * 2))
        ])
    }
}
