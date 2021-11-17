//
//  CompetitionModels.swift
//  StepperApp
//
//  Created by Маргарита Яковлева on 16.11.2021.
//

import Foundation

struct competitionData {
    var name: String?
    var maxValue = 10000.0
    var currentValue = 0.0
    var remainingTime: String?
    var currentLeader: String?
    var text: String?
    var isFinished: Bool {
        if (maxValue > currentValue) {
            return false
        }
        else {
            return true
        }
    }
}

struct timeData {
    var hour = 0
    var minute = 0
    var second = 0
    var time: String = "0 h 0 min"
}

private func timeToString(_ h: Int, _ m: Int) -> String {
    if (m == 0) {
        return "\(24 - h)" + " h " + "\(m)" + " min"
    } else {
        return "\(23 - h)" + " h " + "\(60 - m)" + " min"
    }
}

func currentTime() -> String {
    return timeToString(hour, minute)
}

var allCompetitions = [
    competitionData(name: "Daily step competition", maxValue: 10000, currentValue: Double.random(in: 0...20000.0), remainingTime: currentTime(), currentLeader: "@max", text: "Try to complete 10.000 steps today"),
    competitionData(name: "10 km per day", maxValue: 10, currentValue: Double.random(in: 0...20.0), remainingTime: currentTime(), currentLeader: "@katty", text: "Try to walk 10 km today"),
    competitionData(name: "15000 steps per day", maxValue: 15000, currentValue: Double.random(in: 0...20000.0), remainingTime: currentTime(), currentLeader: "@violla", text: "Try to complete 15.000 steps today"),
    competitionData(name: "Daily step competition", maxValue: 10000, currentValue: Double.random(in: 0...20000.0), remainingTime: currentTime(), currentLeader: "@max", text: "Try to complete 10.000 steps today"),
    competitionData(name: "10 km per day", maxValue: 10, currentValue: Double.random(in: 0...20.0), remainingTime: currentTime(), currentLeader: "@katty", text: "Try to walk 10 km today"),
]


