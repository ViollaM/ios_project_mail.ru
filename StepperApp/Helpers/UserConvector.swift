//
//  UserConvector.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 04.12.2021.
//

import Foundation
import FirebaseFirestore


final class UserConvector {
    enum Key: String {
        case login
        case birthDate
        case isMan
        case imageName
    }
    
    func post(from document: DocumentSnapshot) -> User? {
        guard let dict = document.data(),
              let login = dict[Key.login.rawValue] as? String,
              let birthDate = dict[Key.birthDate.rawValue] as? Date,
              let isMan = dict[Key.isMan.rawValue] as? Bool,
              let imageName = dict[Key.imageName.rawValue] as? String
        else {
            return nil
        }
        
        return User(login: login,
                    birthDate: birthDate,
                    isMan: isMan,
                    imageName: imageName)
    }
}
