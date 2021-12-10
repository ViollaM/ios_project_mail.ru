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
}

final class ProfileServiceImplementation: ProfileService {
        
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
}
