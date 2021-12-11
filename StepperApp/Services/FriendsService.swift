//
//  FriendsService.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 07.12.2021.
//

import Foundation
import Firebase

protocol FriendsService {
    func addFriend(for userId: String, to friendUserName: String, completion: @escaping (Error?) -> Void)
    func getFriends(for userId: String, completion: @escaping (Result<[User], Error>) -> Void)
}

final class FriendsServiceImplementation: FriendsService {
    
    private let usersService = UsersServiceImplementation()
    
    private let db = Firestore.firestore()
    
    func addFriend(for userId: String, to friendUserName: String, completion: @escaping (Error?) -> Void) {
        
        self.usersService.getUserByName(name: friendUserName) {  [weak self] result_request in
            guard self != nil else {
                return
            }
            switch result_request {
            case .success(let friend):
                self?.db.collection("friends").document(userId).setData([
                    friend.id : true,
                ], merge: true){ (error) in
                    if error != nil{
                        completion(error)
                        return
                    }
                }
                self?.db.collection("friends").document(friend.id).setData([
                    userId: true,
                ], merge: true){ (error) in
                    if error != nil{
                        completion(error)
                        return
                    }
                }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    func getFriends(for userId: String, completion: @escaping (Result<[User], Error>) -> Void) {
        self.db.collection("friends").document(userId).getDocument{ documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let document = documentSnapshot else {
                completion(.failure(userError.networkProblem))
                return
            }
            let keys = document.data()?.keys
            guard let keys = keys else {
                completion(.success([]))
                return
            }
            var friends : [User] = []
            for key in keys {
                self.usersService.getUserByUid(uid: key) { [weak self] result in
                    guard self != nil else {
                        return
                    }
                    switch result {
                    case .success(let user):
                        friends.append(user)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    completion(.success(friends))
                }
            }
//            completion(.success(friends))
        }
    }
}
