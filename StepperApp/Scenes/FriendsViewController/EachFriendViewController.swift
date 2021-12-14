//
//  EachFriendViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 17.11.2021.
//

import UIKit

final class EachFriendViewController: UIViewController {
    
    var image: UIImage? {
        didSet {
            avatarImage.image = image
        }
    }
    var friend: User? {
        didSet {
            nameTitle.text = "Hi! I'm @\(friend?.name ?? "user")"
            competitionLabel.text = "@\(friend?.name ?? "user")'s competitions:"
        }
    }
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImage()
        let imageView = CircleImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = StepColor.darkGreen
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    private lazy var competitionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = StepColor.darkGreen
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        button.setTitle("Unfollow", for: .normal)
        button.addTarget(self, action: #selector(unfollowTap), for: .touchUpInside)
        return button
    }()
    private lazy var competitionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FriendsCompetitionsCell.self, forCellWithReuseIdentifier: String(describing: FriendsCompetitionsCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [avatarImage, nameTitle, competitionLabel, competitionsCollectionView, deleteButton].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = StepColor.background
        
        NSLayoutConstraint.activate([
            nameTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameTitle.heightAnchor.constraint(equalToConstant: 34),
            
            avatarImage.topAnchor.constraint(equalTo: nameTitle.bottomAnchor, constant: 24),
            avatarImage.widthAnchor.constraint(equalToConstant: 220),
            avatarImage.heightAnchor.constraint(equalToConstant: 220),
            avatarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            competitionLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 24),
            competitionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            competitionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 40),
            competitionLabel.heightAnchor.constraint(equalToConstant: 24),
            
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 1),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            deleteButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            competitionsCollectionView.topAnchor.constraint(equalTo: competitionLabel.bottomAnchor, constant: 16),
            competitionsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            competitionsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            competitionsCollectionView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -16)
        ])
    }
    
    @objc
    private func unfollowTap() {
    }
}

extension EachFriendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allCompetitions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FriendsCompetitionsCell.self), for: indexPath) as? FriendsCompetitionsCell {
            cell.competition = allCompetitions[indexPath.row]
            cell.numberOfCompetition = indexPath.row + 1
            return cell
        }
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 80, height: 46)
    }
}


