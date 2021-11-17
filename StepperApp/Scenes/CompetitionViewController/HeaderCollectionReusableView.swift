//
//  HeaderCollectionReusableView.swift
//  StepperApp
//
//  Created by Ruben Egikian on 17.11.2021.
//

import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {
      
     lazy var currentCompetitionButton: UIButton = {
        let button = UIButton()
        button.setTitle("current", for: .normal)
        button.setTitleColor(HexColor(rgb: 0x0C2624), for: .normal)
        button.backgroundColor = HexColor(rgb: 0xCCE4E1)
        button.addTarget(self, action: #selector(currentCompetitionButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
     lazy var finishedCompetitionButton: UIButton = {
        let button = UIButton()
        button.setTitle("finished", for: .normal)
        button.setTitleColor(HexColor(rgb: 0x0C2624), for: .normal)
        button.backgroundColor = HexColor(rgb: 0xCCE4E1)
        button.addTarget(self, action: #selector(finishedCompetitionButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc
    private func currentCompetitionButtonPressed() {
        currentCompetitionButton.setTitleColor(HexColor(rgb: 0xCCE4E1), for: .normal)
        currentCompetitionButton.backgroundColor = HexColor(rgb: 0x0C2624)
        finishedCompetitionButton.setTitleColor(HexColor(rgb: 0x0C2624), for: .normal)
        finishedCompetitionButton.backgroundColor = HexColor(rgb: 0xCCE4E1)
    }
    @objc
    private func finishedCompetitionButtonPressed() {
        finishedCompetitionButton.setTitleColor(HexColor(rgb: 0xCCE4E1), for: .normal)
        finishedCompetitionButton.backgroundColor = HexColor(rgb: 0x0C2624)
        currentCompetitionButton.setTitleColor(HexColor(rgb: 0x0C2624), for: .normal)
        currentCompetitionButton.backgroundColor = HexColor(rgb: 0xCCE4E1)
     }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(currentCompetitionButton)
        addSubview(finishedCompetitionButton)
        
        NSLayoutConstraint.activate([
            currentCompetitionButton.topAnchor.constraint(equalTo: self.topAnchor),
            currentCompetitionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -19),
            currentCompetitionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            currentCompetitionButton.widthAnchor.constraint(equalToConstant: (self.frame.width - 22 * (2 + 1)) / 2),

            finishedCompetitionButton.topAnchor.constraint(equalTo: self.topAnchor),
            finishedCompetitionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -19),
            finishedCompetitionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            finishedCompetitionButton.widthAnchor.constraint(equalToConstant: (self.frame.width - 22 * (2 + 1)) / 2)
        ])
    }
}
