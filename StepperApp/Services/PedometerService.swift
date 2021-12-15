//
//  PedometerService.swift
//  StepperApp
//
//  Created by Ruben Egikian on 26.11.2021.
//

import Foundation
import CoreMotion

enum PedometerServiceError: Error {
    case pedometerCountingError
    case pedometerUpdatingError
}

struct PedometerData {
    var steps: NSNumber = 0
    var distance: NSNumber = 0
}

protocol PedometerService {
    func updateStepsAndDistance(completion: @escaping (Result<PedometerData, Error>) -> Void)
    func updateStepsAndDistanceForCompetitions(completion: @escaping (Result<PedometerData, Error>) -> Void)
    func pedometerStop()
    func pedometerCheckForDateChange(newDay: Date) -> Bool
}

final class PedometerServiceImplementation: PedometerService {
    
    private let stepScreenPedometer = CMPedometer()
    private let competitionScreenPedometer = CMPedometer()
    private var oldDate = Date()
    
    func updateStepsAndDistance(completion: @escaping (Result<PedometerData, Error>) -> Void) {
        oldDate = Date()
        var steps: NSNumber = 0
        var distance: NSNumber = 0
        if CMPedometer.isStepCountingAvailable() {
            stepScreenPedometer.startUpdates(from: Date(), withHandler: { (data, error) in
                if let error = error {
                    completion(.failure(PedometerServiceError.pedometerUpdatingError))
                    print("Pedometer failed to update! Error: ", error.localizedDescription)
                }
                if let response = data {
                    distance = response.distance ?? 0
                    steps = response.numberOfSteps
                }
                completion(.success(PedometerData(steps: steps, distance: distance)))
            })
        } else {
            completion(.failure(PedometerServiceError.pedometerCountingError))
        }
    }
    
    func updateStepsAndDistanceForCompetitions(completion: @escaping (Result<PedometerData, Error>) -> Void) {
        var steps: NSNumber = 0
        var distance: NSNumber = 0
        if CMPedometer.isStepCountingAvailable() {
            competitionScreenPedometer.startUpdates(from: Date(), withHandler: { (data, error) in
                if let error = error {
                    completion(.failure(PedometerServiceError.pedometerUpdatingError))
                    print("Pedometer failed to update! Error: ", error.localizedDescription)
                }
                if let response = data {
                    distance = response.distance ?? 0
                    steps = response.numberOfSteps
                }
                self.oldDate = Date()
                completion(.success(PedometerData(steps: steps, distance: distance)))
            })
        } else {
            completion(.failure(PedometerServiceError.pedometerCountingError))
        }
    }
    
    func pedometerStop() {
        stepScreenPedometer.stopUpdates()
    }
    
    func pedometerCheckForDateChange(newDay: Date) -> Bool {
        let newDay = Calendar.iso8601UTC.component(.day, from: newDay)
        let oldDay = Calendar.iso8601UTC.component(.day, from: oldDate)
        if newDay != oldDay {
            return true
        }
        return false
    }
}
