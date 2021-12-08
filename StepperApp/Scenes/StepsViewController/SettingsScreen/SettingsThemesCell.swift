//
//  SettingsThemesCell.swift
//  StepperApp
//
//  Created by Ruben Egikian on 06.12.2021.
//

import UIKit

final class SettingsThemesCell: UICollectionViewCell {
    var theme: String? {
        didSet {
            themeButton.setBackgroundImage(UIImage(named: theme ?? "BG"), for: .normal)
        }
    }
    
    private var themeButton: RoundButton = {
        let button = RoundButton()
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(themeButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private var themeView: RoundView = {
        let view = RoundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func themeButtonClicked() {
        themeButton.layer.borderColor = StepColor.darkGreen.cgColor
    }
    
    private func setupViews() {
        contentView.addSubview(themeButton)
        
        NSLayoutConstraint.activate([
            themeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            themeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            themeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            themeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
