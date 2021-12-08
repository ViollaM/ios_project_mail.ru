//
//  ProfileService.swift
//  StepperApp
//
//  Created by Оля Галягина on 13.11.2021.
//

import Foundation
import UIKit

protocol ProfileService {
    func saveDate(birthdate: Date?)
    func getDate() -> Date?
    func saveImage(image: UIImage?)
    func getImage() -> Data?
    func saveUser(user: User)
    func getUser() -> User
}

final class ProfileServiceImplementation: ProfileService {
    
    private let defaultUser = User(id: "0", login: "", birthDate: Date(), isMan: true, imageName: "")
    
    func saveUserInfo(userName: String, userGender: Bool) {
        UserDefaults.standard.set(userName, forKey: "name")
        UserDefaults.standard.set(userGender, forKey: "gender")
    }
    
    func getUserInfo() -> (String, Bool) {
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        let age = UserDefaults.standard.object(forKey: "age") as? Date
        let gender = UserDefaults.standard.bool(forKey: "gender")
        return (name, gender)
    }
    
    func saveDate(birthdate: Date?)  {
        UserDefaults.standard.set(birthdate, forKey: "age")
    }
    
    func getDate() -> Date? {
        return UserDefaults.standard.object(forKey: "age") as? Date
    }
    
    func saveImage(image: UIImage?)  {
        let jpegData = image?.jpegData(compressionQuality: 0.8)
        UserDefaults.standard.set(jpegData, forKey: "image")
    }
    
    func getImage() -> Data? {
        return UserDefaults.standard.data(forKey: "image")
    }
    
    func saveUser(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "user")
        }
    }
    
    func getUser() -> User {
        if let savedPerson = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                return loadedPerson
            }
            else {return defaultUser}
        }
        else {return defaultUser}
    }
}
