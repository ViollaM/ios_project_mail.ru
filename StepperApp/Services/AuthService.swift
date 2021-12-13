//
//  AuthorizService.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 23.11.2021.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore


protocol AuthService {
    func loginUser(email: String, password: String,completion: @escaping (Error?) -> Void)
    func registrationUser(email: String, name: String, password: String ,completion: @escaping (Error?) -> Void)
    func resetPassword(email: String,completion: @escaping (Error?) -> Void)
}

final class AuthServiceImplementation: AuthService {
    
    private let db = Firestore.firestore()
    
    private let userOperations = UserOperations()
    
    private let usersService = UsersServiceImplementation()
    
    private let usersDefaultImages = ["16B09AAD-E89C-408F-B9DC-17A8A4B3A8D7","16E1F20D-7C3B-48B5-B1B3-071211AD8B74","4F8652AD-8B03-4353-8DD3-B5D1ABBD2352"]
    
    func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Error?) -> Void){
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completion(error)
            } else {
                self.usersService.getUserByUid(uid: result!.user.uid) { [weak self] result_request in
                    guard let self = self else {
                        return
                    }
                    switch result_request {
                    case .success(let user):
                        self.userOperations.saveUser(user: user)
                        completion(nil)
                    case .failure(let error):
                        completion(error)
                    }
                }
            }
        }
    }
    
    func registrationUser(email: String, name: String, password: String,completion: @escaping (Error?) -> Void) {
        
        self.usersService.getUserByName(name: name) { result_request in
            switch result_request {
            case .success(_):
                completion(CustomError.userNameTaken)
            case .failure(let error):
                if error as! CustomError == CustomError.noSuchUser{
                    FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if error != nil {
                            completion(error)
                        } else {
                            let defaultImageName = self.usersDefaultImages[Int.random(in: 0..<3)]
                            self.db.collection("users").document(result!.user.uid).setData([
                                "uid": result!.user.uid,
                                "name": name,
                                "imageName": defaultImageName
                            ]) { (error) in
                                if error != nil{
                                    completion(error)
                                } else {
                                    completion(nil)
                                    let newUser = User(id: result!.user.uid, name: name, imageName: defaultImageName)
                                    self.userOperations.saveUser(user: newUser)
                                }
                            }
                        }
                    }
                } else {
                    completion(error)
                }
            }
        }
    }
}
