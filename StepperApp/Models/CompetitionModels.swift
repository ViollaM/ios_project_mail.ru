//
//  CompetitionModels.swift
//  StepperApp
//
//  Created by Маргарита Яковлева on 16.11.2021.
//

import Foundation

struct CompetitionData {
    var name: String?
    var maxValue = 10000.0
    var currentValue = 0.0
    var remainingTime: String?
    var currentLeader: String?
    var text: String?
    var isStepsCompetition: Bool
    var isFinished: Bool {
        if (maxValue > currentValue) {
            return false
        }
        else {
            return true
        }
    }
}

var date = Date()
let calendar = Calendar.current
var hour = calendar.component(.hour, from: date)
var minute = calendar.component(.minute, from: date)
let second = calendar.component(.second, from: date)
var time = currentTime()

func currentTime(_ h: Int = hour, _ m: Int = minute) -> String {
    if (m == 0) {
        return "\(24 - h)" + " h " + "\(m)" + " min"
    } else {
        return "\(23 - h)" + " h " + "\(60 - m)" + " min"
    }
}

enum CompetitionsState {
    case current
    case finished
    
    func fetch() -> [CompetitionData] {
        switch self {
        case .current : return allCompetitions.filter { !$0.isFinished }
        case .finished : return allCompetitions.filter { $0.isFinished }
        }
    }
}

var allCompetitions = [
    CompetitionData(name: "Daily step competition", maxValue: 10000, remainingTime: currentTime(), currentLeader: "@max", text: "Try to complete 10.000 steps today", isStepsCompetition: true),
    CompetitionData(name: "10 km per day", maxValue: 10, remainingTime: currentTime(), currentLeader: "@katty", text: "Try to walk 10 km today", isStepsCompetition: false),
    CompetitionData(name: "15000 steps per day", maxValue: 15000, remainingTime: currentTime(), currentLeader: "@violla", text: "Try to complete 15.000 steps today", isStepsCompetition: true)
]


