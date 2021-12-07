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
            iconImageView.image = UIImage(named: icon ?? "gob")
        }
    }
    
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
    
    private func setupViews() {
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

