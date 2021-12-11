//
//  TextValidationEnums.swift
//  StepperApp
//
//  Created by Оля Галягина on 16.11.2021.
//

import Foundation

enum Alert {
    case success
    case failure
    case error
}
enum Valid {
    case success
    case failure(Alert, AlertMessages)
}
enum ValidationType {
    case userEmail
    case userName
    case userAge
    case userPassword
}
enum RegEx: String {
    case userEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    case userPassword = "^.{6,15}$"
    case userName = "^[a-zA-Z0-9-].{1,5}$"
    case userAge = "^100|[1-9]?[0-9]$"
}
enum AlertMessages: String {
    case inValidEmail = "InvalidEmail"
    case inValidAge = "Invalid Age"
    case inValidName = "Invalid Name"
    case inValidPassword = "Invalid Password"
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

final class Validation: NSObject {
    
    public static let shared = Validation()
    
    func validate(values: (type: ValidationType, inputValue: String)...) -> (Valid, Character) {
        for valueToBeChecked in values {
            switch valueToBeChecked.type {
            case .userEmail:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .userEmail, .inValidEmail)) {
                    return (tempValue, "e")
                }
            case .userAge:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .userAge, .inValidAge)) {
                    return (tempValue, "a")
                }
            case .userName:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .userName, .inValidName)) {
                    return (tempValue, "n")
                }
            case .userPassword:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .userPassword, .inValidPassword)) {
                    return (tempValue, "p")
                }
            }
        }
        return (.success, "s")
    }
    
    func isValidString(_ input: (text: String, regex: RegEx, invalidAlert: AlertMessages)) -> Valid? {
        if isValidRegEx(input.text, input.regex) != true {
            return .failure(.error, input.invalidAlert)
        }
        return nil
    }
    
    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
}
