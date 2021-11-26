//
//  PedometerService.swift
//  StepperApp
//
//  Created by Ruben Egikian on 26.11.2021.
//

import Foundation
import CoreMotion

enum PedometerServiceError: Error {
    case stepCountingError
    case stepUpdatingError
}

protocol PedometerService {
    func updateStepsInfo(completion: @escaping (Result<NSNumber, Error>) -> Void)
}

final class PedometerServiceImplementation: PedometerService {
    
    private let pedometer = CMPedometer()
    
    func updateStepsInfo(completion: @escaping (Result<NSNumber, Error>) -> Void) {
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date(), withHandler: { (data, error) in
                if let error = error {
                    completion(.failure(PedometerServiceError.stepUpdatingError))
                    print("Pedometer failed to update! Error: ", error.localizedDescription)
                }
                if let response = data {
                    completion(.success(response.numberOfSteps))
                }
            })
        } else {
            completion(.failure(PedometerServiceError.stepCountingError))
        }
    }
}
