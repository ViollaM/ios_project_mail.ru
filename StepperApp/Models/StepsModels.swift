//
//  SteppingWeek.swift
//  StepperApp
//
//  Created by Ruben Egikian on 23.10.2021.
//

import Foundation

struct SteppingWeek {
    let steppingDays: [SteppingDay]
}

struct SteppingDay {
    var steps: Int = 0
    var km: Double = 0
    var date: Date = Date()
}
