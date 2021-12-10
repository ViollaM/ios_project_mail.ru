//
//  FriendsListViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit
import PinLayout
import PanModal
import Presentr

final class FriendsListViewController: UIViewController {
    
    private let presenter: Presentr = {
        let width = ModalSize.custom(size: Float(UIScreen.main.bounds.width - 60))
        let height = ModalSize.fluid(percentage: 0.25)
        let center = ModalCenterPosition.center
        let presentr = Presentr(presentationType: .custom(width: width, height: height, center: center))
        presentr.transitionType = .crossDissolve
        presentr.dismissTransitionType = .crossDissolve
        presentr.roundCorners = true
        presentr.cornerRadius = 12
        presentr.backgroundOpacity = 0.5
        presentr.backgroundColor = .black.withAlphaComponent(0.4)
        return presentr
    }()
    private let newFriendVC = NewFriendViewController()
    private var allUsers = friends
    private var filteredUsers: [User] = []
    
    private let searchController: UISearchController = {
        let search = UISearchController()
        search.searchBar.tintColor = StepColor.darkGreen
        return search
    }()
    
    private lazy var addingFriendView: UIView = {
        let view = UIView()
        view.backgroundColor = StepColor.cellBackground
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FriendsListCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: FriendsListCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private let cellWidth = UIScreen.main.bounds.width - 36
    private let cellHeight = CGFloat(70)

    override func viewDidLoad() {
        setupData()
        setupNavigationItem()
        setupLayout()
    }

    private func setupNavigationItem () {
        self.navigationItem.searchController = searchController
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addingNewFriend))
        self.navigationItem.rightBarButtonItem?.tintColor = StepColor.darkGreen
    }
    
    private func setupLayout () {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupData() {
        searchController.searchResultsUpdater = self
        filteredUsers = allUsers
    }
    
    @objc
    private func addingNewFriend() {
//        presentPanModal(newFriendVC)
        customPresentViewController(presenter, viewController: newFriendVC, animated: true, completion: nil)
    }
}

extension FriendsListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FriendsListCollectionViewCell.self), for: indexPath) as! FriendsListCollectionViewCell
        cell.friend = filteredUsers[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let friendsVC = EachFriendViewController()
        let friend = filteredUsers[indexPath.row]
        friendsVC.friend = friend
        present(friendsVC, animated: true, completion: nil)
    }
}

extension FriendsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(){
                if searchText.count == 0 {
                    filteredUsers = allUsers
                }
                else {
                    filteredUsers = allUsers.filter {
                        return $0.name.lowercased().contains(searchText)
                    }
                }
            }
            self.collectionView.reloadData()
    }
}
