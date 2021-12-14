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
}

struct Goal {
    var steps: Int?
    var distance: Double?
    var isSteps: Bool
    var isKM: Bool = true
}
