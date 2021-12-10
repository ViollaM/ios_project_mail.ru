//
//  SettingsHeader.swift
//  StepperApp
//
//  Created by Ruben Egikian on 07.12.2021.
//
import UIKit

final class SettingsHeader: UICollectionReusableView {
    var text: String? {
        didSet {
            sectionTitleLabel.text = text
        }
    }
    
    private lazy var sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = StepColor.darkGreen
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = StepColor.darkGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(sectionTitleLabel)
        addSubview(lineView)
        
        NSLayoutConstraint.activate([
            sectionTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -39),
            sectionTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -39),
            lineView.heightAnchor.constraint(equalToConstant: 2),
            lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor)

        ])
    }
}
