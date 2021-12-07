//
//  FriendsList.swift
//  StepperApp
//
//  Created by Ruben Egikian on 11.11.2021.
//

struct Friend {
    let name: String
    let imageName: String = "Photo"
    var age: Int = 0
    var isMan: Bool = true
}

let friends: [User] = [
    User(login: "John", isMan: true),
    User(login: "Jack", isMan: true),
    User(login: "Ann", isMan: false),
    User(login: "Lisa",  isMan: false),
    User(login: "Winston",  isMan: true),
    User(login: "Rebecca",  isMan: false),
    User(login: "Will", isMan: true),
    User(login: "Andrew",  isMan: true),
    User(login: "Rose", isMan: false),
    User(login: "Francis", isMan: false)
]
