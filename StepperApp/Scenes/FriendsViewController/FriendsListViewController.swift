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
    
    private let imageLoaderService: ImageLoaderService
    private let friendsService: FriendsService
    
    init(friendsService: FriendsService, imageLoaderService: ImageLoaderService) {
        self.imageLoaderService = imageLoaderService
        self.friendsService = friendsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let presenter: Presentr = {
        let width = ModalSize.custom(size: Float(UIScreen.main.bounds.width - 60))
        let height = ModalSize.fluid(percentage: 0.25)
        let center = ModalCenterPosition.topCenter
        let presentr = Presentr(presentationType: .custom(width: width, height: height, center: center))
        presentr.transitionType = .crossDissolve
        presentr.dismissTransitionType = .crossDissolve
        presentr.roundCorners = true
        presentr.cornerRadius = 12
        presentr.backgroundOpacity = 0.5
        presentr.backgroundColor = .black.withAlphaComponent(0.4)
        return presentr
    }()
    private var allFriends: [User] = []
    private var filteredFriends: [User] = []
    
    private let searchController: UISearchController = {
        let search = UISearchController()
        search.searchBar.autocorrectionType = .no
        search.searchBar.autocapitalizationType = .none
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
    private var plusButton: UIButton = {
        let plus = UIButton()
        let config = UIImage.SymbolConfiguration(weight: .bold)
        if let plusImage = UIImage(systemName: "plus", withConfiguration: config) {
            plus.setImage(plusImage, for: .normal)
        }
        plus.tintColor = StepColor.darkGreen
        plus.layer.cornerRadius = 10
        plus.backgroundColor = StepColor.cellBackground
        plus.frame.size = CGSize(width: 28, height: 28)
        return plus
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
        getFriends()
        setupData()
        setupNavigationItem()
        setupLayout()
    }
    
    private func getFriends() {
        if let id = UserOperations().getUser()?.id {
            friendsService.getFriends(for: id) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let friends):
                    DispatchQueue.main.async {
                        self.allFriends = friends
                        self.filteredFriends = friends
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    displayAlert(message: error.localizedDescription, viewController: self)
                }
            }
        }
    }

    private func setupNavigationItem () {
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        plusButton.addTarget(self, action: #selector(addingNewFriend), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusButton)
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
        filteredFriends = allFriends
    }
    
    @objc
    private func addingNewFriend() {
        let newFriendVC = NewFriendViewController()
        newFriendVC.delegate = self
        customPresentViewController(presenter, viewController: newFriendVC, animated: true, completion: nil)
    }
}

extension FriendsListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FriendsListCollectionViewCell.self), for: indexPath) as? FriendsListCollectionViewCell {
            cell.friend = filteredFriends[indexPath.row]
            return cell
        }
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let friendsVC = EachFriendViewController(friendsService: friendsService)
        friendsVC.delegate = self
        let friend = filteredFriends[indexPath.row]
        imageLoaderService.getImage(with: friend.imageName) { [weak weakVC = friendsVC] image in
            guard let image = image, let friendsVC = weakVC else { return }
            DispatchQueue.main.async {
                friendsVC.image = image
            }
        }
        friendsVC.friend = friend
        present(friendsVC, animated: true, completion: nil)
    }
    
}

extension FriendsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let friend = filteredFriends[indexPath.row]
        imageLoaderService.getImage(with: friend.imageName) { [weak weakCell = cell] image in
            guard let image = image, let friendsCell = weakCell as? FriendsListCollectionViewCell else { return }
            DispatchQueue.main.async {
                friendsCell.image = image
            }
        }
    }
}

extension FriendsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(){
                if searchText.count == 0 {
                    filteredFriends = allFriends
                }
                else {
                    filteredFriends = allFriends.filter {
                        return $0.name.lowercased().contains(searchText)
                    }
                }
            }
            self.collectionView.reloadData()
    }
}

extension FriendsListViewController: NewFriendDelegate {
    func searchForUser(nickname: String) {
        let userId = UserOperations().getUser()!.id
        friendsService.addFriend(for: userId, to: nickname) { [weak self] error in
            guard let self = self else {
                return
            }
            switch error {
            case nil:
                displayAlert(alertTitle: "Congratulations!",message: "You have followed to \(nickname)!", viewController: self)
                    self.getFriends()
            default:
                displayAlert(message: error!.localizedDescription, viewController: self)
            }
        }
    }
}

extension FriendsListViewController: FriendsChangeDelegate {
    func removedUserWith(id: String) {
        self.getFriends()
        displayAlert(alertTitle: "",message: "You are unfollowed successfully", viewController: self)
    }
}
