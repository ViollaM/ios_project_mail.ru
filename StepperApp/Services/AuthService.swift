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
                completion(nil)
                self.usersService.getUserByUid(uid: result!.user.uid) { [weak self] result_request in
                    guard self != nil else {
                        return
                    }
                    switch result_request {
                    case .success(let user):
                        completion(nil)
                        print(user.birthDate)
                        self?.userOperations.saveUser(user: user)
                    case .failure(let error):
                        completion(error)
                    }
                }
            }
        }
    }
    
    func registrationUser(email: String, name: String, password: String,completion: @escaping (Error?) -> Void) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completion(error)
            } else {
                self.db.collection("users").document(result!.user.uid).setData([
                    "uid": result!.user.uid,
                    "name": name
                ]) { (error) in
                    if error != nil{
                        completion(error)
                    } else {
                        completion(nil)
                        let newUser = User(id: result!.user.uid, name: name)
                        self.userOperations.saveUser(user: newUser)
                    }
                }
            }
        }
    }
    
}
