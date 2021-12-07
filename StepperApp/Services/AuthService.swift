//
//  AuthorizService.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 23.11.2021.
//

import Foundation
import Firebase
import FirebaseAuth

protocol AuthService {
    func loginUser(email: String, password: String,completion: @escaping (Error?) -> Void)
    func registrationUser(email: String, name: String, password: String ,completion: @escaping (Error?) -> Void)
    func resetPassword(email: String,completion: @escaping (Error?) -> Void)
}

final class AuthServiceImplementation: AuthService {
    
    private let db = Firestore.firestore()
    
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
            }
        }
    }
    
    func registrationUser(email: String, name: String, password: String,completion: @escaping (Error?) -> Void) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription )
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
                    }
                }
            }
        }
    }
    
}
