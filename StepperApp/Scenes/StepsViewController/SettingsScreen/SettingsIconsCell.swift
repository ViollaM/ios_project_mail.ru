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
        }
    }
    private var iconButton: RoundButton = {
        let button = RoundButton()
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(iconButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private var iconImageView: RoundedImageView = {
        let image = UIImage()
        let imageView = RoundedImageView(image: image)
        imageView.backgroundColor = StepColor.cellBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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

