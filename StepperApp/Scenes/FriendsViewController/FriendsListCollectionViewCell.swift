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
            avatarImage.image = UIImage(named: friend?.imageName ?? "AppIcon")
            nameLabel.text = "Hi! I'm @\(friend!.name)"
        }
    }
    
    var friendName = ""
    
    var avatarImage: UIImageView = {
        let image = UIImage()
        let imageView = CircleImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 12/255, green: 38/255, blue: 36/255, alpha: 1)
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
        contentView.backgroundColor = UIColor(red: 204/255, green: 228/255, blue: 225/255, alpha: 1)
        
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalTo: avatarImage.heightAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -46)
        ])
        
    }
}

