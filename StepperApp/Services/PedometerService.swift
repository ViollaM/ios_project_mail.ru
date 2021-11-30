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
    case distanceCountingError
    case distanceUpdatingError
}

struct PedometerData {
    var steps: NSNumber = 0
    var distance: NSNumber = 0
}

protocol PedometerService {
//    func updateStepsAndDistance(completion: @escaping (Result<(steps: NSNumber, distance: NSNumber), Error>) -> Void)
    func updateSteps(completion: @escaping (Result<NSNumber, Error>) -> Void)
    func updateDistance(completion: @escaping (Result<NSNumber, Error>) -> Void)
    func updateStepsAndDistance(completion: @escaping (Result<PedometerData, Error>) -> Void)
}

final class PedometerServiceImplementation: PedometerService {
    
    private let stepsPedometer = CMPedometer()
    private let distancePedometer = CMPedometer()
    
//    func updateStepsAndDistance(completion: @escaping (Result<(steps: NSNumber, distance: NSNumber), Error>) -> Void) {
    func updateStepsAndDistance(completion: @escaping (Result<PedometerData, Error>) -> Void) {
        var steps: NSNumber = 0
        var distance: NSNumber = 0
        let group = DispatchGroup()
        if CMPedometer.isStepCountingAvailable() {
            group.enter()
            stepsPedometer.startUpdates(from: Date(), withHandler: { (data, error) in
                if let error = error {
                    completion(.failure(PedometerServiceError.stepUpdatingError))
                    print("Pedometer failed to update! Error: ", error.localizedDescription)
                }
                if let response = data {
                    steps = response.numberOfSteps
                }
                group.leave()
            })
        } else {
            completion(.failure(PedometerServiceError.stepCountingError))
        }
    
        if CMPedometer.isDistanceAvailable() {
            group.enter()
            distancePedometer.startUpdates(from: Date(), withHandler: { (data, error) in
                if let error = error {
                    completion(.failure(PedometerServiceError.distanceUpdatingError))
                    print("Pedometer failed to update! Error: ", error.localizedDescription)
                }
                if let response = data {
                    distance = response.distance ?? 0
                }
                group.leave()
            })
        } else {
            completion(.failure(PedometerServiceError.distanceCountingError))
        }
        group.notify(queue: .main) {
            var pedometerInfo = PedometerData()
            pedometerInfo.distance = distance
            pedometerInfo.steps = steps
            completion(.success(pedometerInfo))
//            completion(.success((steps, distance)))
        }
    }
    
    
    func updateSteps(completion: @escaping (Result<NSNumber, Error>) -> Void) {
        if CMPedometer.isStepCountingAvailable() {
            stepsPedometer.startUpdates(from: Date(), withHandler: { (data, error) in
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
    
    func updateDistance(completion: @escaping (Result<NSNumber, Error>) -> Void) {
        if CMPedometer.isDistanceAvailable() {
            distancePedometer.startUpdates(from: Date(), withHandler: { (data, error) in
                if let error = error {
                    completion(.failure(PedometerServiceError.distanceUpdatingError))
                    print("Pedometer failed to update! Error: ", error.localizedDescription)
                }
                if let response = data {
                    completion(.success(response.distance ?? 0))
                }
            })
        } else {
            completion(.failure(PedometerServiceError.distanceCountingError))
        }
    }
}
