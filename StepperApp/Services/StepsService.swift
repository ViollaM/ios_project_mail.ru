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
    func fetchLastWeekInfo(completion: @escaping (Result<SteppingWeek, Error>) -> Void)
    func authorizeService(completion: @escaping (Result<Bool,Error>) -> Void)
    func fetchWeekBefore(day: Date, completion: @escaping (Result<SteppingWeek, Error>) -> Void)
}

final class StepsServiceImplementation: StepsService {
    
    private var healthStore = HKHealthStore()
    private let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    private let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
//    private let date = Date()
    private let calendar = Calendar.current

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
    
    func fetchLastWeekInfo(completion: @escaping (Result<SteppingWeek, Error>) -> Void) {
        var stepsDataValues: [HKStatistics] = []
        var distanceDataValues: [HKStatistics] = []
        var weekDates: [Date] = []
        var weekSteps: [Int] = []
        var weekDistance: [Double] = []
        let group = DispatchGroup()
        let anchor = setupLastWeekAnchor(date: Date(), daysBefore: 6)
        let predicate = setupLastWeekPredicate()
        let interval = DateComponents(day: 1)
        
        let stepsCollectionQuery = HKStatisticsCollectionQuery(quantityType: stepType,
                                                          quantitySamplePredicate: predicate,
                                                          options: .cumulativeSum,
                                                          anchorDate: anchor,
                                                          intervalComponents: interval)
        group.enter()
        stepsCollectionQuery.initialResultsHandler = { query, statisticsCollection, error in
            if let error = error {
                print("Query handler error:", error.localizedDescription)
            }

            if let statisticsCollection = statisticsCollection {
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
                statisticsCollection.enumerateStatistics(from: startDate,
                                                         to: Date()) { (statistics, stop) in
                    stepsDataValues.append(statistics)
                }
                var date = startDate
                for _ in 1...7 {
                    weekDates.append(date)
                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                }
                let count = HKUnit.count()
                for i in 0...6 {
                    weekSteps.append(Int((stepsDataValues[i].sumQuantity()?.doubleValue(for: count)) ?? 0))
                }
                group.leave()
            }
        }
        healthStore.execute(stepsCollectionQuery)
        
        let distanceCollectionQuery = HKStatisticsCollectionQuery(quantityType: distanceType,
                                                          quantitySamplePredicate: predicate,
                                                          options: .cumulativeSum,
                                                          anchorDate: anchor,
                                                          intervalComponents: interval)
        group.enter()
        distanceCollectionQuery.initialResultsHandler = { query, statisticsCollection, error in
            if let error = error {
                print("Query handler error:", error.localizedDescription)
            }

            if let statisticsCollection = statisticsCollection {
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
                statisticsCollection.enumerateStatistics(from: startDate,
                                                         to: Date()) { (statistics, stop) in
                    distanceDataValues.append(statistics)
                }
                let meter = HKUnit.meter()
                for i in 0...6 {
                    weekDistance.append(distanceDataValues[i].sumQuantity()!.doubleValue(for: meter) / 1000)
                }
                group.leave()
            }
        }
        healthStore.execute(distanceCollectionQuery)
        group.notify(queue: .main) {
            var days: [SteppingDay] = []
            for i in 0...6 {
                days.append(SteppingDay(steps: weekSteps[i], km: weekDistance[i], date: weekDates[i]))
            }
            let weekData = SteppingWeek(steppingDays: days)
            completion(.success(weekData))
        }
    }

    func fetchWeekBefore(day: Date, completion: @escaping (Result<SteppingWeek, Error>) -> Void) {
        var stepsDataValues: [HKStatistics] = []
        var distanceDataValues: [HKStatistics] = []
        var weekDates: [Date] = []
        var weekSteps: [Int] = []
        var weekDistance: [Double] = []
        let group = DispatchGroup()
        let anchor = setupLastWeekAnchor(date: day, daysBefore: 6)
        let predicate = setupWeekPredicateBefore(day: setupDayEndFrom(date: day))
        let interval = DateComponents(day: 1)
        
        let stepsCollectionQuery = HKStatisticsCollectionQuery(quantityType: stepType,
                                                          quantitySamplePredicate: predicate,
                                                          options: .cumulativeSum,
                                                          anchorDate: anchor,
                                                          intervalComponents: interval)
        group.enter()
        stepsCollectionQuery.initialResultsHandler = { query, statisticsCollection, error in
            if let error = error {
                print("Query handler error:", error.localizedDescription)
            }

            if let statisticsCollection = statisticsCollection {
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: day)!
                statisticsCollection.enumerateStatistics(from: startDate,
                                                         to: day) { (statistics, stop) in
                    stepsDataValues.append(statistics)
                }
                var date = startDate
                for _ in 1...7 {
                    weekDates.append(date)
                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                }
                let count = HKUnit.count()
                for i in 0...6 {
                    weekSteps.append(Int((stepsDataValues[i].sumQuantity()?.doubleValue(for: count)) ?? 0))
                }
                group.leave()
            }
        }
        healthStore.execute(stepsCollectionQuery)
        
        let distanceCollectionQuery = HKStatisticsCollectionQuery(quantityType: distanceType,
                                                          quantitySamplePredicate: predicate,
                                                          options: .cumulativeSum,
                                                          anchorDate: anchor,
                                                          intervalComponents: interval)
        group.enter()
        distanceCollectionQuery.initialResultsHandler = { query, statisticsCollection, error in
            if let error = error {
                print("Query handler error:", error.localizedDescription)
            }

            if let statisticsCollection = statisticsCollection {
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: day)!
                statisticsCollection.enumerateStatistics(from: startDate,
                                                         to: day) { (statistics, stop) in
                    distanceDataValues.append(statistics)
                }
                let meter = HKUnit.meter()
                for i in 0...6 {
                    weekDistance.append(distanceDataValues[i].sumQuantity()!.doubleValue(for: meter) / 1000)
                }
                group.leave()
            }
        }
        healthStore.execute(distanceCollectionQuery)
        group.notify(queue: .main) {
            var days: [SteppingDay] = []
            for i in 0...6 {
                days.append(SteppingDay(steps: weekSteps[i], km: weekDistance[i], date: weekDates[i]))
            }
            let weekData = SteppingWeek(steppingDays: days)
            completion(.success(weekData))
        }
    }
    
    func fetchWeekAfter(day: Date, completion: @escaping (Result<SteppingWeek, Error>) -> Void) {
        var stepsDataValues: [HKStatistics] = []
        var distanceDataValues: [HKStatistics] = []
        var weekDates: [Date] = []
        var weekSteps: [Int] = []
        var weekDistance: [Double] = []
        let group = DispatchGroup()
        let endOfDay = setupDayEndFrom(date: day)
        let anchor = setupLastWeekAnchor(date: endOfDay)
        let predicate = setupWeekPredicateBefore(day: endOfDay)
        let interval = DateComponents(day: 1)
        
        let stepsCollectionQuery = HKStatisticsCollectionQuery(quantityType: stepType,
                                                          quantitySamplePredicate: predicate,
                                                          options: .cumulativeSum,
                                                          anchorDate: anchor,
                                                          intervalComponents: interval)
        group.enter()
        stepsCollectionQuery.initialResultsHandler = { query, statisticsCollection, error in
            if let error = error {
                print("Query handler error:", error.localizedDescription)
            }

            if let statisticsCollection = statisticsCollection {
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: day)!
                statisticsCollection.enumerateStatistics(from: startDate,
                                                         to: day) { (statistics, stop) in
                    stepsDataValues.append(statistics)
                }
                var date = startDate
                for _ in 1...7 {
                    weekDates.append(date)
                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                }
                let count = HKUnit.count()
                for i in 0...6 {
                    weekSteps.append(Int((stepsDataValues[i].sumQuantity()?.doubleValue(for: count)) ?? 0))
                }
                group.leave()
            }
        }
        healthStore.execute(stepsCollectionQuery)
        
        let distanceCollectionQuery = HKStatisticsCollectionQuery(quantityType: distanceType,
                                                          quantitySamplePredicate: predicate,
                                                          options: .cumulativeSum,
                                                          anchorDate: anchor,
                                                          intervalComponents: interval)
        group.enter()
        distanceCollectionQuery.initialResultsHandler = { query, statisticsCollection, error in
            if let error = error {
                print("Query handler error:", error.localizedDescription)
            }

            if let statisticsCollection = statisticsCollection {
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: day)!
                statisticsCollection.enumerateStatistics(from: startDate,
                                                         to: day) { (statistics, stop) in
                    distanceDataValues.append(statistics)
                }
                let meter = HKUnit.meter()
                for i in 0...6 {
                    weekDistance.append(distanceDataValues[i].sumQuantity()!.doubleValue(for: meter) / 1000)
                }
                group.leave()
            }
        }
        healthStore.execute(distanceCollectionQuery)
        group.notify(queue: .main) {
            var days: [SteppingDay] = []
            for i in 0...6 {
                days.append(SteppingDay(steps: weekSteps[i], km: weekDistance[i], date: weekDates[i]))
            }
            let weekData = SteppingWeek(steppingDays: days)
            completion(.success(weekData))
        }
    }

    
    // MARK: Support functions

    private func setupLastWeekPredicate() -> NSPredicate {
        let exactlySevenDaysAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
        let oneWeekAgo = HKQuery.predicateForSamples(withStart: exactlySevenDaysAgo, end: nil, options: .strictStartDate)
        return oneWeekAgo
    }
    
    private func setupWeekPredicateBefore(day: Date) -> NSPredicate {
        let exactlySevenDaysAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: day)!
        let oneWeekAgo = HKQuery.predicateForSamples(withStart: exactlySevenDaysAgo, end: day, options: .strictStartDate)
        return oneWeekAgo
    }
    
    private func setupLastWeekAnchor(date: Date, daysBefore: Int = 0) -> Date {
        let dayComponents = getDateComponents(date: date)
        var components = DateComponents()
        components.day = -daysBefore
        components.hour = -dayComponents.hour
        components.minute = -dayComponents.minute
        components.second = -dayComponents.second
        let anchor = Calendar.current.date(byAdding: components, to: date) ?? Date()
        return anchor
    }
    
    private func setupDayEndFrom(date: Date) -> Date {
        let dayComponents = getDateComponents(date: date)
        let hourDifference = 23 - dayComponents.hour
        let minuteDifference = 59 - dayComponents.hour
        let secondDifference = 59 - dayComponents.second
        var components = DateComponents()
        components.hour = hourDifference
        components.minute = minuteDifference
        components.second = secondDifference
        let newDate = calendar.date(byAdding: components, to: date) ?? date
        return newDate
    }
    
    private func getDateComponents(date: Date) -> (hour: Int, minute: Int, second: Int) {
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        return (hour: hour, minute: minute, second: second)
    }
}
