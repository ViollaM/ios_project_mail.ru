//
//  FriendsListCollectionViewCell.swift
//  StepperApp
//
//  Created by Ruben Egikian on 11.11.2021.
//

import UIKit

final class FriendsListCollectionViewCell: UICollectionViewCell {
    
    var friend: Friend? {
        didSet {
            avatarImage.image = UIImage(named: friend?.imageName ?? "Photo")
            nameLabel.text = "@\(friend?.name ?? "User")"
        }
    }
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImage()
        let imageView = CircleImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = StepColor.darkGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FriendsListCollectionViewCell {
    private func setupViews() {
        [avatarImage, nameLabel].forEach {
            contentView.addSubview($0)
        }
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = StepColor.cellBackground
        
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 25),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalTo: avatarImage.heightAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -46)
        ])
    }
}

