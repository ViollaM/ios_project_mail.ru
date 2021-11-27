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

let friends: [Friend] = [
    Friend(name: "John", age: 25, isMan: true),
    Friend(name: "Jack", age: 31, isMan: true),
    Friend(name: "Ann", age: 22, isMan: false),
    Friend(name: "Lisa", age: 19, isMan: false),
    Friend(name: "Winston", age: 27, isMan: true),
    Friend(name: "Rebecca", age: 33, isMan: false),
    Friend(name: "Will", age: 51, isMan: true),
    Friend(name: "Andrew", age: 13, isMan: true),
    Friend(name: "Rose", age: 16, isMan: false),
    Friend(name: "Francis", age: 35, isMan: false)
]
