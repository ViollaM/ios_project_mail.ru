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
    
    init(name: String, maxValue: Double, currentValue: Double, remainingTime: String, currentLeader: String)
        {
            self.name = name
            self.maxValue = maxValue
            self.currentValue = currentValue
            self.remainingTime = remainingTime
            self.currentLeader = currentLeader
        }
}

struct timeData {
    var hour = 0
    var minute = 0
    var second = 0
    var time: String = "00:00:00"
    
    init(hour: Int, minute: Int, second: Int, time: String)
        {
            self.hour = hour
            self.minute = minute
            self.second = second
            self.time = time
        }
}
