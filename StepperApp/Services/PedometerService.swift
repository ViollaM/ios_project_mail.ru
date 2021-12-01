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
}

final class PedometerServiceImplementation: PedometerService {
    
    private let pedometer = CMPedometer()

    func updateStepsAndDistance(completion: @escaping (Result<PedometerData, Error>) -> Void) {
        var steps: NSNumber = 0
        var distance: NSNumber = 0
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date(), withHandler: { (data, error) in
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
}
