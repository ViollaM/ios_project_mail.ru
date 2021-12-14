//
//  UsersDBService.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 28.11.2021.
//

import Foundation
import Firebase
import UIKit

enum userError: Error {
    case networkProblem
}

protocol UsersService {
    func updateUser(user: User, completion: @escaping (Error?) -> Void)
    func getUserByUid(uid: String, completion: @escaping (Result<User,Error>) -> Void)
    func getUserByName(name: String, completion: @escaping (Result<User,Error>) -> Void)
}


final class UsersServiceImplementation: UsersService {
    
    private let userConvector = UserConvector()
    
    private let db = Firestore.firestore()
    
    func updateUser(user: User,  completion: @escaping (Error?) -> Void) {
        let group = DispatchGroup()
        group.enter()
        self.getUserByName(name: user.name) { result_request in
            switch result_request {
            case .success(let base_user):
                if base_user.id != user.id{
                    completion(CustomError.userNameTaken)
                    return
                } else {
                    group.leave()
                }
            case .failure(let error):
                if error as! CustomError == CustomError.noSuchUser{
                    print("Имя свободно")
                    group.leave()
                } else {
                    completion(error)
                    return
                }
            }
        }
        
        group.notify(queue: .main) {
            self.db.collection("users").document(user.id).setData([
                "uid": user.id,
                "name": user.name,
                "birthDate": user.birthDate,
                "isMan": user.isMan,
                "imageName": user.imageName,
                "steps": user.steps,
                "km": user.km,
                "miles": user.miles
            ], merge: true){ (error) in
                if error != nil{
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    
    func getUserByUid(uid: String, completion: @escaping (Result<User,Error>) -> Void){
        self.db.collection("users").document(uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let document = documentSnapshot else {
                completion(.failure(CustomError.parseDBProblem))
                return
            }
            
            let user = self.userConvector.dictToUser(from: document)
            guard let user = user else {
                completion(.failure(CustomError.noSuchUser))
                return
            }
            completion(.success(user))
        }
    }
    
    func getUserByName(name: String, completion: @escaping (Result<User,Error>) -> Void){
        self.db.collection("users").whereField("name", isEqualTo: name).getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else {
                return
            }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.failure(CustomError.parseDBProblem))
                return
            }
            
            let users = documents.compactMap{ self.userConvector.dictToUser(from: $0)}
            
            if users.count == 0{
                completion(.failure(CustomError.noSuchUser))
                return
            }
            completion(.success(users[0]))
        }
    }
}

