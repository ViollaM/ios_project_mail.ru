//
//  StepsService.swift
//  StepperApp
//
//  Created by Ruben Egikian on 23.10.2021.
//
import Foundation
import HealthKit

enum StepsServiceError: Error {
    case healthDataUnavailable
    case authError
    case handlerError
}

protocol StepsService {
    func fetchLastWeekSteps(completion: @escaping (Result<SteppingWeek, Error>) -> Void)
    func fetchLastWeekDistance(completion: @escaping (Result<SteppingWeek, Error>) -> Void)
    func authorizeService(completion: @escaping (Result<Bool,Error>) -> Void)
}

final class StepsServiceImplementation: StepsService {
    
    private var healthStore = HKHealthStore()
    private var stepsCollectionQuery: HKStatisticsCollectionQuery?
    private var distanceCollectionQuery: HKStatisticsCollectionQuery?
    private var stepsDataValues: [HKStatistics] = []
    private var distanceDataValues: [HKStatistics] = []
    private var stepsDatesArray: [Date] = []
    private var distanceDatesArray: [Date] = []
    private let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    private let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
    private let date = Date()
    private let calendar = Calendar.current
    private let count = HKUnit.count()
//    private var isPermissionAllowed = false
    var weekData = SteppingWeek(steppingDays: [])
    var distanceWeekData = SteppingWeek(steppingDays: [])
    
    
    func authorizeService(completion: @escaping (Result<Bool,Error>) -> Void) {
        let allTypes = Set([stepType, distanceType])
        if !HKHealthStore.isHealthDataAvailable() {
            completion(.failure(StepsServiceError.healthDataUnavailable))
            return
        }
        
        print("Requesting HealthKit authorization...")
        self.healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if let error = error {
                completion(.failure(StepsServiceError.authError))
                print("requestAuthorization error:", error.localizedDescription)
            }
            if success {
                completion(.success(true))
                print("HealthKit authorization request was successful!")
            } else {
                completion(.success(false))
                print("HealthKit authorization was not successful.")
            }
        }
    }
    
    func fetchLastWeekSteps(completion: @escaping (Result<SteppingWeek, Error>) -> Void) {

        let anchor = setupLastWeekAnchor()
        let predicate = setupSamplePredicate()
        let interval = DateComponents(day: 1)
        
        self.stepsCollectionQuery = HKStatisticsCollectionQuery(quantityType: stepType,
                                                          quantitySamplePredicate: predicate,
                                                          options: .cumulativeSum,
                                                          anchorDate: anchor,
                                                          intervalComponents: interval)
        self.stepsCollectionQuery?.initialResultsHandler = { query, statisticsCollection, error in
            if let error = error {
                print("Query handler error:", error.localizedDescription)
            }

            if let statisticsCollection = statisticsCollection {
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
                statisticsCollection.enumerateStatistics(from: startDate,
                                                         to: Date()) { (statistics, stop) in
                    self.stepsDataValues.append(statistics)
                }
                var date = startDate
                for _ in 1...7 {
                    self.stepsDatesArray.append(date)
                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                }
                var days: [SteppingDay] = []
                
                for i in 0...6 {
                    days.append(SteppingDay(steps: Int((self.stepsDataValues[i].sumQuantity()?.doubleValue(for: self.count)) ?? 0), date: self.stepsDatesArray[i]))
                }
                let weekResult = SteppingWeek(steppingDays: days)
                self.weekData = weekResult
                completion(.success(self.weekData))
            }
        }
        healthStore.execute(stepsCollectionQuery!)
    }
    
    func fetchLastWeekDistance(completion: @escaping (Result<SteppingWeek, Error>) -> Void) {

        let anchor = setupLastWeekAnchor()
        let predicate = setupSamplePredicate()
        let interval = DateComponents(day: 1)
        
        self.distanceCollectionQuery = HKStatisticsCollectionQuery(quantityType: distanceType,
                                                          quantitySamplePredicate: predicate,
                                                          options: .cumulativeSum,
                                                          anchorDate: anchor,
                                                          intervalComponents: interval)
        self.distanceCollectionQuery?.initialResultsHandler = { query, statisticsCollection, error in
            if let error = error {
                print("Query handler error:", error.localizedDescription)
            }

            if let statisticsCollection = statisticsCollection {
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
                statisticsCollection.enumerateStatistics(from: startDate,
                                                         to: Date()) { (statistics, stop) in
                    self.distanceDataValues.append(statistics)
                }
                var date = startDate
                for _ in 1...7 {
                    self.distanceDatesArray.append(date)
                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                }
                var days: [SteppingDay] = []
                let meter = HKUnit.meter()
                for i in 0...6 {
                    days.append(SteppingDay(steps: Int((self.distanceDataValues[i].sumQuantity()?.doubleValue(for: meter)) ?? 0), date: self.distanceDatesArray[i]))
                }
                let weekResult = SteppingWeek(steppingDays: days)
                self.distanceWeekData = weekResult
                completion(.success(self.distanceWeekData))
            }
        }
        healthStore.execute(distanceCollectionQuery!)
    }


    
    // MARK: Support functions

    private func setupSamplePredicate() -> NSPredicate {
        let exactlySevenDaysAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
        let oneWeekAgo = HKQuery.predicateForSamples(withStart: exactlySevenDaysAgo, end: nil, options: .strictStartDate)
        return oneWeekAgo
    }
    
    private func setupLastWeekAnchor() -> Date {
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        var components = DateComponents()
        components.day = -6
        components.hour = -hour
        components.minute = -minute
        components.second = -second
        let anchor = Calendar.current.date(byAdding: components, to: date) ?? Date()
        return anchor
    }
}
