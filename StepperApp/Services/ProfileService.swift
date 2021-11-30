//
//  ProfileService.swift
//  StepperApp
//
//  Created by Оля Галягина on 13.11.2021.
//

import Foundation
import UIKit

protocol ProfileService {
    func saveUserInfo(userName: String, userAge: String, userGender: Int, userPicture: UIImage?)
    func getUserInfo() -> (String, String, Int, Data?)
}

final class ProfileServiceImplementation: ProfileService {
    
    func saveUserInfo(userName: String, userAge: String, userGender: Int, userPicture: UIImage?) {
        UserDefaults.standard.set(userName, forKey: "name")
        UserDefaults.standard.set(userAge, forKey: "age")
        UserDefaults.standard.set(userGender, forKey: "gender")
        let jpegData = userPicture?.jpegData(compressionQuality: 0.8)
        UserDefaults.standard.set(jpegData, forKey: "image")
    }
    
    func getUserInfo() -> (String, String, Int, Data?) {
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        let age = UserDefaults.standard.string(forKey: "age") ?? ""
        let gender = UserDefaults.standard.integer(forKey: "gender")
        let img = UserDefaults.standard.data(forKey: "image")
        return (name, age, gender, img)
    }
}
