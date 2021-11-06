//
//  StepsService.swift
//  StepperApp
//
//  Created by Ruben Egikian on 23.10.2021.
//
import Foundation

protocol StepsService {
    func fetchMonthSteps(for month: Date) -> [SteppingWeek]
}

//final class StepsServiceImplementation: StepsService {
//    func fetchMonthSteps(for month: Date) -> [SteppingWeek] {
//
//    }
//}
