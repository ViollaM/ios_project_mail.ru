//
//  SettingsIconsCell.swift
//  StepperApp
//
//  Created by Ruben Egikian on 06.12.2021.
//

import UIKit

final class SettingsIconsCell: UICollectionViewCell {
    var icon: String? {
        didSet {
            iconButton.setBackgroundImage(UIImage(named: icon ?? "gow"), for: .normal)
            let image = UIImage(named: icon ?? "gow")
            let lockedImage = image?.mergeWith(topImage: UIImage(systemName: "lock")!)
            iconButton.setBackgroundImage(lockedImage, for: .disabled)
            iconButton.setBackgroundImage(image, for: .normal)
            if icon == "gow" {
                iconButton.isEnabled = true
            }
        }
    }
    private var iconButton: RoundButton = {
        let button = RoundButton()
        button.tintColor = StepColor.darkGreen
        button.backgroundColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        button.isEnabled = false
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        //        button.addTarget(self, action: #selector(iconButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func iconButtonClicked() {
        iconButton.layer.borderColor = StepColor.darkGreen.cgColor
        let jpegData = iconButton.backgroundImage(for: .normal)?.jpegData(compressionQuality: 0.8)
        UserDefaults.standard.set(jpegData, forKey: "icon")
    }
    
    private func setupViews() {
        contentView.addSubview(iconButton)
        
        NSLayoutConstraint.activate([
            iconButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            iconButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

