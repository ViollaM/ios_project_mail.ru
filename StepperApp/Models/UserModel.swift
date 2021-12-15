//
//  UserModel.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 04.12.2021.
//

import Foundation

struct User: Codable {
    let id: String
    var name: String
    var birthDate: Date?
    var isMan: Bool?
    var imageName: String
    var steps: Int = 0
    var km: Double = 0
    var miles: Double = 0
}

struct Goal: Equatable {
    var steps: Int = 10000
    var distance: Double = 10
    var isSteps: Bool = true
    var isKM: Bool = true
    
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        return (lhs.steps == rhs.steps) && (lhs.distance == rhs.distance) && (lhs.isSteps == rhs.isSteps) && (lhs.isKM == rhs.isKM)
    }
}
