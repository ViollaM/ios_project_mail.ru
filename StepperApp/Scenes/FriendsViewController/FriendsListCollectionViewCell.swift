//
//  FriendsListCollectionViewCell.swift
//  StepperApp
//
//  Created by Ruben Egikian on 11.11.2021.
//

import UIKit

final class FriendsListCollectionViewCell: UICollectionViewCell {
        
    var image: UIImage? {
        didSet {
            avatarImage.image = image
        }
    }
    var friend: User? {
        didSet {
            if let user = friend {
                nameLabel.text = "@\(user.name)"
                stepsLabel.text = "Steps: \(user.steps)"
                if let male = user.isMan {
                    genderImage.isHidden = false
                    if male {
                        let image = UIImage(named: "manSign")!
                        let tintableImage = image.withRenderingMode(.alwaysTemplate)
                        genderImage.image = tintableImage
                        genderImage.tintColor = .blue
                    } else {
                        let image = UIImage(named: "womanSign")!
                        let tintableImage = image.withRenderingMode(.alwaysTemplate)
                        genderImage.image = tintableImage
                        genderImage.tintColor = .systemPink
                    }
                }
                if let age = user.birthDate {
                    ageLabel.text = "age: " + String(getAge(birthdate: age))
                }
            }
        }
    }
        
    private lazy var avatarImage: UIImageView = {
        let image = UIImage()
        let imageView = CircleImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var genderImage: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = StepColor.darkGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = StepColor.darkGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stepsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .gray
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
        [avatarImage, nameLabel, stepsLabel, genderImage, ageLabel].forEach {
            contentView.addSubview($0)
        }
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = StepColor.cellBackground
        
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 22),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            nameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            stepsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stepsLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            stepsLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 1),
            stepsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            ageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 4),
            ageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            ageLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            genderImage.centerXAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: -4),
            genderImage.centerYAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: -8),
            genderImage.heightAnchor.constraint(equalToConstant: 25),
            genderImage.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func getAge(birthdate: Date) -> Int {
        let calendar = Calendar.current
        let now = calendar.dateComponents([.year, .month, .day], from: Date())
        let birthdate = calendar.dateComponents([.year, .month, .day], from: birthdate)
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
        let age = ageComponents.year!
        return age
    }
}

