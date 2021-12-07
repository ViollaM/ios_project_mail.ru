//
//  UserModel.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 04.12.2021.
//

import Foundation

struct User {
    var id: String = ""
    let login: String
    var birthDate: Date = Date()
    var isMan: Bool = true
    var imageName: String = "Photo"
}
