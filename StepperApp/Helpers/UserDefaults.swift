//
//  UserDefaults.swift
//  StepperApp
//
//  Created by Оля Галягина on 08.12.2021.
//

import Foundation

final class UserOperations {
    
    func saveUser(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "user")
        }
    }
    
    func getUser() -> User? {
        if let savedPerson = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                return loadedPerson
            }
            else {return nil}
        }
        else {return nil}
    }
    
    func cleanSetupUserDefaults(){
        UserDefaults.standard.removeObject(forKey: "image")
        UserDefaults.standard.removeObject(forKey: "km_miles")
        UserDefaults.standard.removeObject(forKey: "stepsGoal")
        UserDefaults.standard.removeObject(forKey: "distanceGoal")
        UserDefaults.standard.removeObject(forKey: "steps_distance")
    }
}
