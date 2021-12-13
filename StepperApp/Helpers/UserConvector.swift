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
        case uid
        case name
        case birthDate
        case isMan
        case imageName
    }
    
    func dictToUser(from document: DocumentSnapshot) -> User? {
        guard let dict = document.data(),
              let uid = dict[Key.uid.rawValue] as? String,
              let name = dict[Key.name.rawValue] as? String,
              let imageName = dict[Key.imageName.rawValue] as? String
        else {
            return nil
        }
        
        print(dict)
        let birthDate = dict[Key.birthDate.rawValue] as? Timestamp
        let isMan = dict[Key.isMan.rawValue] as? Bool
        
        return User(id: uid,
                    name: name,
                    birthDate: birthDate?.dateValue(),
                    isMan: isMan,
                    imageName: imageName)
    }
}
