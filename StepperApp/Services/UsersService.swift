//
//  UsersDBService.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 28.11.2021.
//

import Foundation
import Firebase


protocol UsersService {
    func updateUser(id_user: String, name: String, birthdate: String, male: String, completion: @escaping (Error?) -> Void)
}


final class UsersServiceImplementation: UsersService {
    
    private let db = Firestore.firestore()
    
    func updateUser(id_user: String, name: String, birthdate: String, male: String, completion: @escaping (Error?) -> Void) {
        self.db.collection("users").document(name).setData([
            "name": name,
            "birthdate": birthdate,
            "male": male,
        ], merge: true){ (error) in
                if error != nil{
                    completion(error)
                } else {
                    completion(nil)
                }
            }
    }
}

