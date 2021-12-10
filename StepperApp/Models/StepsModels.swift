//
//  SteppingWeek.swift
//  StepperApp
//
//  Created by Ruben Egikian on 23.10.2021.
//

import Foundation

struct SteppingWeek {
    let steppingDays: [SteppingDay]
    var totalStepsForWeek: Int {
        var total = 0
        steppingDays.forEach { day in
            total += day.steps
        }
        return total
    }
    var totalDistanceInKM: Double {
        var total: Double = 0
        steppingDays.forEach { day in
            total += day.km
        }
        return total
    }
    var totalDistanceInMiles: Double {
        var total: Double = 0
        steppingDays.forEach { day in
            total += day.miles
        }
        return total
    }
    var averageStepsForWeek: Int {
        Int(totalStepsForWeek/steppingDays.count)
    }
}

struct SteppingDay {
    var steps: Int = 0
    var km: Double = 0
    var miles: Double = 0
    var date: Date = Date()
}
