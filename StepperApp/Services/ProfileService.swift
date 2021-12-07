//
//  ProfileService.swift
//  StepperApp
//
//  Created by Оля Галягина on 13.11.2021.
//

import Foundation
import UIKit

protocol ProfileService {
    func saveUserInfo(userName: String, userGender: Int, userPicture: UIImage?)
    func getUserInfo() -> (String, Date?, Int, Data?)
    func saveDate(birthdate: Date?)
    func getDate() -> Date?
}

final class ProfileServiceImplementation: ProfileService {
    
    func saveUserInfo(userName: String, userGender: Int, userPicture: UIImage?) {
        UserDefaults.standard.set(userName, forKey: "name")
        UserDefaults.standard.set(userGender, forKey: "gender")
        let jpegData = userPicture?.jpegData(compressionQuality: 0.8)
        UserDefaults.standard.set(jpegData, forKey: "image")
    }
    
    func getUserInfo() -> (String, Date?, Int, Data?) {
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        let age = UserDefaults.standard.object(forKey: "age") as? Date
        let gender = UserDefaults.standard.integer(forKey: "gender")
        let img = UserDefaults.standard.data(forKey: "image")
        return (name, age, gender, img)
    }
    
    func saveDate(birthdate: Date?)  {
        UserDefaults.standard.set(birthdate, forKey: "age")
    }
    
    func getDate() -> Date? {
        return UserDefaults.standard.object(forKey: "age") as? Date
    }
}
