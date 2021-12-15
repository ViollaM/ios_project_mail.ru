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
    func removeFriend(for userId: String, to friendUserId: String, completion: @escaping (Error?) -> Void)
    func getFriends(for userId: String, completion: @escaping (Result<[User], Error>) -> Void)
}

final class FriendsServiceImplementation: FriendsService {
    
    private let usersService = UsersServiceImplementation()
    
    private let db = Firestore.firestore()
    
    func addFriend(for userId: String, to friendUserName: String, completion: @escaping (Error?) -> Void) {
        
        usersService.getUserByName(name: friendUserName) {  [weak self] result_request in
            guard let self = self else {
                return
            }
            switch result_request {
            case .success(let friend):
                if friend.id == userId {
                    completion(CustomError.addYourselfFriend)
                    return
                }
                
                self.db.collection("friends").document(userId).getDocument { (documentSnapshot, error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    guard let document = documentSnapshot else {
                        completion(CustomError.parseDBProblem)
                        return
                    }
                    if let friend = document[friend.id] {
                        if (friend as! Bool) {
                            completion(CustomError.friendAlreadyAdded)
                            return
                        }
                    }
                    
                    self.db.collection("friends").document(userId).setData([
                        friend.id : true,
                    ], merge: true){ (error) in
                        if error != nil{
                            completion(error)
                            return
                        }
                    }
                    completion(nil)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func removeFriend(for userId: String, to friendUserId: String, completion: @escaping (Error?) -> Void) {
        self.db.collection("friends").document(userId).setData([
            friendUserId : false,
        ], merge: true){ (error) in
            if error != nil{
                completion(error)
                return
            }
        }
        completion(nil)
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
            var friends: [User] = []
            let group = DispatchGroup()
            
            for key in keys {
                if document[key]! as! Bool {
                    group.enter()
                    self.usersService.getUserByUid(uid: key) { result in
                        switch result {
                        case .success(let user):
                            friends.append(user)
                        case .failure(let error):
                            completion(.failure(error))
                            return
                        }
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                completion(.success(friends))
            }
        }
    }
}
