//
//  CustomErrors.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 11.12.2021.
//

import Foundation


public enum CustomError: Error {
    case noSuchUser
    case parseDBProblem
    case userNameTaken
    case addYourselfFriend
    case friendAlreadyAdded
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noSuchUser:
            return NSLocalizedString("There is no such user in the application database.", comment: "My error")
        case .parseDBProblem:
            return NSLocalizedString("The problem with parsing data and working with the database.", comment: "My error")
        case .userNameTaken:
            return NSLocalizedString("This username is already taken. Choose another.", comment: "My error")
        case .addYourselfFriend:
            return NSLocalizedString("You can't add yourself as a friend.", comment: "My error")
        case .friendAlreadyAdded:
            return NSLocalizedString("This friend has already been added.", comment: "My error")
        }
        
    }
}

