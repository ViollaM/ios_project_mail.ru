//
//  UsersDBService.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 28.11.2021.
//

import Foundation
import Firebase
import UIKit


protocol UsersService {
    func updateUser(user: User, completion: @escaping (Error?) -> Void)
}


final class UsersServiceImplementation: UsersService {
    
    private let userConvector = UserConvector()
    
    private let imageLoaderService = ImageLoaderServiceImplementation()
    
    private let db = Firestore.firestore()
    
    func updateUser(user: User,  completion: @escaping (Error?) -> Void) {
        
        self.db.collection("users").document(user.id).setData([
            "name": user.login,
            "birthdate": user.birthDate,
            "male": user.isMan,
            "image": user.imageName,
        ], merge: true){ (error) in
                if error != nil{
                    completion(error)
                } else {
                    completion(nil)
                }
            }
    }
}

