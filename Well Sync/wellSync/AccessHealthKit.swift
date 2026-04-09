////
////  File.swift
////  wellSync
////
////  Created by Vidit Agarwal on 11/02/26.
////
//
//import Foundation
//import HealthKit
//import UIKit
//class AccessHealthKit{
//    var healthStore: HKHealthStore = HKHealthStore()
//    
//    init(){
//        requestHealthPermission()
//    }
//    func requestHealthPermission() {
//            if HKHealthStore.isHealthDataAvailable() {
//                let readTypes: Set<HKObjectType> = [
//                    HKObjectType.quantityType(forIdentifier: .heartRate)!,
//                    HKObjectType.quantityType(forIdentifier: .stepCount)!,
//                    HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
//                    HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
//                    HKObjectType.quantityType(forIdentifier: .height)!,
//                    HKObjectType.quantityType(forIdentifier: .bodyMass)!
//                ]
//
//                healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
//                    if success {
//                        print("HealthKit Permission Granted")
//                    } else {
//                        print("HealthKit Permission Failed")
//                    }
//                }
//            }
//        }
//
//        // MARK: - Fetch Functions
//
//    func fetchHeartRate(_ heartRateLabel:UILabel) {
//            fetchLatestSample(type: .heartRate, unit: HKUnit(from: "count/min")) {
//                heartRateLabel.text = "\($0)"
//            }
//        }
//
//    func fetchSteps(_ stepsLabel:UILabel) {
//            fetchLatestSample(type: .stepCount, unit: HKUnit.count()) {
//                stepsLabel.text = "\($0)"
//            }
//        }
//
//    func fetchCalories(_ caloriesLabel:UILabel) {
//            fetchLatestSample(type: .activeEnergyBurned, unit: HKUnit.kilocalorie()) {
//                caloriesLabel.text = "\($0)"
//            }
//        }
//
//    func fetchSpO2(_ spo2Label: UILabel) {
//            fetchLatestSample(type: .oxygenSaturation, unit: HKUnit.percent()) {
//                spo2Label.text = "🩸 SpO2: \(Double($0)! * 100)%"
//            }
//        }
//
//    func fetchHeight(_ heightLabel : UILabel) {
//            fetchLatestSample(type: .height, unit: HKUnit.meter()) {
//            heightLabel.text = "🧍 Height: \($0) m"
//            }
//        }
//
//    func fetchWeight(_ weightLabel : UILabel) {
//            fetchLatestSample(type: .bodyMass, unit: HKUnit.gramUnit(with: .kilo)) {
//                weightLabel.text = "⚖️ Weight: \($0) kg"
//            }
//        }
//
//        // MARK: - Generic Fetch
//
//        func fetchLatestSample(type: HKQuantityTypeIdentifier, unit: HKUnit, completion: @escaping (String) -> Void) {
//            guard let sampleType = HKQuantityType.quantityType(forIdentifier: type) else { return }
//
//            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//            let query = HKSampleQuery(sampleType: sampleType,
//                                      predicate: nil,
//                                      limit: 1,
//                                      sortDescriptors: [sortDescriptor]) { _, results, _ in
//                if let sample = results?.first as? HKQuantitySample {
//                    let value = sample.quantity.doubleValue(for: unit)
//                    DispatchQueue.main.async {
//                        completion(String(format: "%.2f", value))
//                    }
//                }
//            }
//
//            healthStore.execute(query)
//        }
//
//    // MARK: - Date Range Fetch
//
//    /// Fetches quantity samples for a given type within a date range.
//    /// - Parameters:
//    ///   - type: The `HKQuantityTypeIdentifier` to query.
//    ///   - unit: The unit to convert each sample's quantity value.
//    ///   - startDate: The beginning of the date range (inclusive).
//    ///   - endDate: The end of the date range (exclusive by default for HealthKit predicates).
//    ///   - limit: Maximum number of samples to return. Defaults to `HKObjectQueryNoLimit`.
//    ///   - completion: Called on the main thread with an array of tuples (date, value) or an error.
//    func fetchSamples(in range: (startDate: Date, endDate: Date),
//                      for type: HKQuantityTypeIdentifier,
//                      unit: HKUnit,
//                      limit: Int = HKObjectQueryNoLimit,
//                      completion: @escaping (Result<[(date: Date, value: Double)], Error>) -> Void) {
//        
//        guard let sampleType = HKQuantityType.quantityType(forIdentifier: type) else {
//            DispatchQueue.main.async {
//                completion(.failure(NSError(domain: "AccessHealthKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid quantity type"])))
//            }
//            return
//        }
//
//        let predicate = HKQuery.predicateForSamples(withStart: range.startDate, end: range.endDate, options: [.strictStartDate])
//        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
//
//        let query = HKSampleQuery(sampleType: sampleType,
//                                  predicate: predicate,
//                                  limit: limit,
//                                  sortDescriptors: [sortDescriptor]) { [weak self] _, results, error in
//            guard let _ = self else { return }
//            if let error = error {
//                DispatchQueue.main.async { completion(.failure(error)) }
//                return
//            }
//
//            let mapped: [(date: Date, value: Double)] = (results as? [HKQuantitySample])?.map { sample in
//                let value = sample.quantity.doubleValue(for: unit)
//                return (date: sample.startDate, value: value)
//            } ?? []
//
//            DispatchQueue.main.async { completion(.success(mapped)) }
//        }
//
//        healthStore.execute(query)
//    }
//
//    /// Convenience: Fetches samples in a date range and returns a formatted string using an aggregator.
//    /// - Parameters:
//    ///   - type: The `HKQuantityTypeIdentifier` to query.
//    ///   - unit: The unit to convert each sample's quantity value.
//    ///   - startDate: Start date of the range.
//    ///   - endDate: End date of the range.
//    ///   - aggregation: How to aggregate the values (e.g., sum or average).
//    ///   - formatter: Optional custom formatter for the resulting value.
//    ///   - completion: Called on the main thread with the formatted result string.
//    func fetchAggregatedValue(in range: (startDate: Date, endDate: Date),
//                              for type: HKQuantityTypeIdentifier,
//                              unit: HKUnit,
//                              aggregation: Aggregation = .sum,
//                              formatter: ((Double) -> String)? = nil,
//                              completion: @escaping (String) -> Void) {
//        fetchSamples(in: range, for: type, unit: unit) { result in
//            switch result {
//            case .failure:
//                completion("--")
//            case .success(let samples):
//                let values = samples.map { $0.value }
//                let aggregated: Double
//                switch aggregation {
//                case .sum:
//                    aggregated = values.reduce(0, +)
//                case .average:
//                    aggregated = values.isEmpty ? 0 : values.reduce(0, +) / Double(values.count)
//                case .min:
//                    aggregated = values.min() ?? 0
//                case .max:
//                    aggregated = values.max() ?? 0
//                }
//                if let formatter = formatter {
//                    completion(formatter(aggregated))
//                } else {
//                    completion(String(format: "%.2f", aggregated))
//                }
//            }
//        }
//    }
//
//    /// Convenience: Fetch samples for the last 7 days (from now - 7 days to now).
//    func fetchLast7DaysSamples(for type: HKQuantityTypeIdentifier,
//                               unit: HKUnit,
//                               limit: Int = HKObjectQueryNoLimit,
//                               completion: @escaping (Result<[(date: Date, value: Double)], Error>) -> Void) {
//        let endDate = Date()
//        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate) ?? endDate.addingTimeInterval(-7 * 24 * 60 * 60)
//        fetchSamples(in: (startDate, endDate), for: type, unit: unit, limit: limit, completion: completion)
//    }
//
//    /// Convenience: Fetch aggregated value over the last 7 days.
//    func fetchLast7DaysAggregatedValue(for type: HKQuantityTypeIdentifier,
//                                       unit: HKUnit,
//                                       aggregation: Aggregation = .sum,
//                                       formatter: ((Double) -> String)? = nil,
//                                       completion: @escaping (String) -> Void) {
//        let endDate = Date()
//        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate) ?? endDate.addingTimeInterval(-7 * 24 * 60 * 60)
//        fetchAggregatedValue(in: (startDate, endDate), for: type, unit: unit, aggregation: aggregation, formatter: formatter, completion: completion)
//    }
//
//    enum Aggregation {
//        case sum
//        case average
//        case min
//        case max
//    }
//}

import Foundation
import HealthKit

class AccessHealthKit {
    
    // This is the main HealthKit object — think of it as the "door" to health data
    let healthStore = HKHealthStore()
    static let healthKit = AccessHealthKit()
    
    // This runs automatically when you create AccessHealthKit()
    init() {
        askForPermission()
    }
    
    // MARK: - Step 1: Ask User for Permission
    
    func askForPermission() {
        // Check if this device supports HealthKit (iPhones do, some iPads don't)
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit not available on this device")
            return
        }
        
        // Tell HealthKit which data types you want to READ
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,      // Steps
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!   // Sleep
        ]
        
        // Show the permission popup to the user
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
            if success {
                print("✅ Permission granted!")
            } else {
                print("❌ Permission denied: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    // MARK: - Step 2: Fetch Steps
    
    // Call this function to get steps data
    // "howManyDaysBack" = how many past days you want (e.g. 7 = last 7 days)
    // "completion" = a block of code that runs when the data is ready
    func getSteps(howManyDaysBack days: Int,
                  completion: @escaping ([Date: Double]) -> Void) {
        
        // 1. Figure out the date range
        let endDate   = Date()  // today/now
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: endDate)!
        
        // 2. Get the step count type
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        // 3. Create a filter to only get data in our date range
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        // 4. Create the query
        let query = HKSampleQuery(sampleType: stepType,
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { _, results, error in
            
            // If something went wrong, return empty
            if let error = error {
                print("Steps error: \(error)")
                DispatchQueue.main.async { completion([:]) }
                return
            }
            
            // 5. Group steps by day and add them up
            // (Apple Watch records steps every few minutes, so we sum per day)
            var stepsByDay: [Date: Double] = [:]
            
            for sample in (results as? [HKQuantitySample]) ?? [] {
                let day = Calendar.current.startOfDay(for: sample.startDate) // strip the time, keep only the date
                let steps = sample.quantity.doubleValue(for: .count())
                stepsByDay[day, default: 0] += steps // add to that day's total
            }
            
            // 6. Send the result back on the main thread (safe for UI updates)
            DispatchQueue.main.async {
                completion(stepsByDay)
            }
        }
        
        // 5. Run the query
        healthStore.execute(query)
    }
    
    // MARK: - Step 3: Fetch Sleep
    
    // This is a single sleep record — makes it easy to understand each sleep interval
    struct SleepRecord {
        var startTime: Date
        var endTime: Date
        var stage: String       // e.g. "Deep Sleep", "REM Sleep", "Awake"
        var durationMinutes: Double
    }
    
    // Call this function to get sleep data
    func getSleep(howManyNightsBack nights: Int,
                  completion: @escaping ([SleepRecord]) -> Void) {
        
        // 1. Use noon-to-noon range so we don't cut overnight sessions in half
        //    e.g. if tonight = April 8, we go from April 1 noon → April 8 noon
        let calendar  = Calendar.current
        let noonToday = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        let startDate = calendar.date(byAdding: .day, value: -nights, to: noonToday)!
        
        // 2. Get the sleep type
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        // 3. Create a filter for our date range
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: noonToday)
        
        // 4. Create the query
        let query = HKSampleQuery(sampleType: sleepType,
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { _, results, error in
            
            // If something went wrong, return empty
            if let error = error {
                print("Sleep error: \(error)")
                DispatchQueue.main.async { completion([]) }
                return
            }
            
            // 5. Convert each raw sample into our simple SleepRecord
            var sleepRecords: [SleepRecord] = []
            
            for sample in (results as? [HKCategorySample]) ?? [] {
                
                // Figure out what stage this interval is
                let stage: String
                switch HKCategoryValueSleepAnalysis(rawValue: sample.value) {
                case .inBed:             stage = "In Bed"
                case .awake:             stage = "Awake"
                case .asleepCore:        stage = "Core Sleep"
                case .asleepDeep:        stage = "Deep Sleep"
                case .asleepREM:         stage = "REM Sleep"
                case .asleep,
                     .asleepUnspecified: stage = "Asleep"
                default:                 stage = "Unknown"
                }
                
                // Calculate how long this interval lasted
                let durationMinutes = sample.endDate.timeIntervalSince(sample.startDate) / 60
                
                // Build our simple record
                let record = SleepRecord(startTime: sample.startDate,
                                         endTime: sample.endDate,
                                         stage: stage,
                                         durationMinutes: durationMinutes)
                sleepRecords.append(record)
            }
            
            // 6. Send the result back on the main thread
            DispatchQueue.main.async {
                completion(sleepRecords)
            }
        }
        
        // 7. Run the query
        healthStore.execute(query)
    }
    // Fetch steps for a specific date range (used by the cell)
    func getSteps(from startDate: Date, to endDate: Date,
                  completion: @escaping ([Date: Double]) -> Void) {

        let stepType  = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)

        let query = HKSampleQuery(sampleType: stepType,
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { _, results, error in

            if let error = error {
                print("Steps error: \(error)")
                DispatchQueue.main.async { completion([:]) }
                return
            }

            var stepsByDay: [Date: Double] = [:]
            for sample in (results as? [HKQuantitySample]) ?? [] {
                let day = Calendar.current.startOfDay(for: sample.startDate)
                stepsByDay[day, default: 0] += sample.quantity.doubleValue(for: .count())
            }

            DispatchQueue.main.async { completion(stepsByDay) }
        }

        healthStore.execute(query)
    }

    // Fetch sleep for a specific date range (used by the cell)
    func getSleep(from startDate: Date, to endDate: Date,
                  completion: @escaping ([SleepRecord]) -> Void) {

        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)

        let query = HKSampleQuery(sampleType: sleepType,
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { _, results, error in

            if let error = error {
                print("Sleep error: \(error)")
                DispatchQueue.main.async { completion([]) }
                return
            }

            var records: [SleepRecord] = []
            for sample in (results as? [HKCategorySample]) ?? [] {
                let stage: String
                switch HKCategoryValueSleepAnalysis(rawValue: sample.value) {
                case .inBed:             stage = "In Bed"
                case .awake:             stage = "Awake"
                case .asleepCore:        stage = "Core Sleep"
                case .asleepDeep:        stage = "Deep Sleep"
                case .asleepREM:         stage = "REM Sleep"
                case .asleep,
                     .asleepUnspecified: stage = "Asleep"
                default:                 stage = "Unknown"
                }

                let durationMinutes = sample.endDate.timeIntervalSince(sample.startDate) / 60
                records.append(SleepRecord(startTime: sample.startDate,
                                           endTime: sample.endDate,
                                           stage: stage,
                                           durationMinutes: durationMinutes))
            }

            DispatchQueue.main.async { completion(records) }
        }

        healthStore.execute(query)
    }
}
