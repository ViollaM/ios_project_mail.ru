//
//  SettingsThemesCell.swift
//  StepperApp
//
//  Created by Ruben Egikian on 06.12.2021.
//

import UIKit

final class SettingsThemesCell: UICollectionViewCell {
    var theme: UIColor? {
        didSet {
            themeView.backgroundColor = theme
        }
    }
    
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
}

extension SettingsThemesCell {
    private func setupViews() {
        contentView.addSubview(themeView)
        
        NSLayoutConstraint.activate([
            themeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            themeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            themeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            themeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
