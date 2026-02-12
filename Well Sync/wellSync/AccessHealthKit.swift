//
//  File.swift
//  wellSync
//
//  Created by Vidit Agarwal on 11/02/26.
//

import Foundation
import HealthKit
import UIKit
class AccessHealthKit{
    var healthStore: HKHealthStore = HKHealthStore()
    
    init(){
        requestHealthPermission()
    }
    func requestHealthPermission() {
            if HKHealthStore.isHealthDataAvailable() {
                let readTypes: Set<HKObjectType> = [
                    HKObjectType.quantityType(forIdentifier: .heartRate)!,
                    HKObjectType.quantityType(forIdentifier: .stepCount)!,
                    HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                    HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
                    HKObjectType.quantityType(forIdentifier: .height)!,
                    HKObjectType.quantityType(forIdentifier: .bodyMass)!
                ]

                healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
                    if success {
                        print("HealthKit Permission Granted")
                    } else {
                        print("HealthKit Permission Failed")
                    }
                }
            }
        }

        // MARK: - Fetch Functions

    func fetchHeartRate(_ heartRateLabel:UILabel) {
            fetchLatestSample(type: .heartRate, unit: HKUnit(from: "count/min")) {
                heartRateLabel.text = "\($0)"
            }
        }

    func fetchSteps(_ stepsLabel:UILabel) {
            fetchLatestSample(type: .stepCount, unit: HKUnit.count()) {
                stepsLabel.text = "\($0)"
            }
        }

    func fetchCalories(_ caloriesLabel:UILabel) {
            fetchLatestSample(type: .activeEnergyBurned, unit: HKUnit.kilocalorie()) {
                caloriesLabel.text = "\($0)"
            }
        }

    func fetchSpO2(_ spo2Label: UILabel) {
            fetchLatestSample(type: .oxygenSaturation, unit: HKUnit.percent()) {
                spo2Label.text = "🩸 SpO2: \(Double($0)! * 100)%"
            }
        }

    func fetchHeight(_ heightLabel : UILabel) {
            fetchLatestSample(type: .height, unit: HKUnit.meter()) {
            heightLabel.text = "🧍 Height: \($0) m"
            }
        }

    func fetchWeight(_ weightLabel : UILabel) {
            fetchLatestSample(type: .bodyMass, unit: HKUnit.gramUnit(with: .kilo)) {
                weightLabel.text = "⚖️ Weight: \($0) kg"
            }
        }

        // MARK: - Generic Fetch

        func fetchLatestSample(type: HKQuantityTypeIdentifier, unit: HKUnit, completion: @escaping (String) -> Void) {
            guard let sampleType = HKQuantityType.quantityType(forIdentifier: type) else { return }

            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: sampleType,
                                      predicate: nil,
                                      limit: 1,
                                      sortDescriptors: [sortDescriptor]) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    let value = sample.quantity.doubleValue(for: unit)
                    DispatchQueue.main.async {
                        completion(String(format: "%.2f", value))
                    }
                }
            }

            healthStore.execute(query)
        }

    // MARK: - Date Range Fetch

    /// Fetches quantity samples for a given type within a date range.
    /// - Parameters:
    ///   - type: The `HKQuantityTypeIdentifier` to query.
    ///   - unit: The unit to convert each sample's quantity value.
    ///   - startDate: The beginning of the date range (inclusive).
    ///   - endDate: The end of the date range (exclusive by default for HealthKit predicates).
    ///   - limit: Maximum number of samples to return. Defaults to `HKObjectQueryNoLimit`.
    ///   - completion: Called on the main thread with an array of tuples (date, value) or an error.
    func fetchSamples(in range: (startDate: Date, endDate: Date),
                      for type: HKQuantityTypeIdentifier,
                      unit: HKUnit,
                      limit: Int = HKObjectQueryNoLimit,
                      completion: @escaping (Result<[(date: Date, value: Double)], Error>) -> Void) {
        
        guard let sampleType = HKQuantityType.quantityType(forIdentifier: type) else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "AccessHealthKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid quantity type"])))
            }
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: range.startDate, end: range.endDate, options: [.strictStartDate])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)

        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: predicate,
                                  limit: limit,
                                  sortDescriptors: [sortDescriptor]) { [weak self] _, results, error in
            guard let _ = self else { return }
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            let mapped: [(date: Date, value: Double)] = (results as? [HKQuantitySample])?.map { sample in
                let value = sample.quantity.doubleValue(for: unit)
                return (date: sample.startDate, value: value)
            } ?? []

            DispatchQueue.main.async { completion(.success(mapped)) }
        }

        healthStore.execute(query)
    }

    /// Convenience: Fetches samples in a date range and returns a formatted string using an aggregator.
    /// - Parameters:
    ///   - type: The `HKQuantityTypeIdentifier` to query.
    ///   - unit: The unit to convert each sample's quantity value.
    ///   - startDate: Start date of the range.
    ///   - endDate: End date of the range.
    ///   - aggregation: How to aggregate the values (e.g., sum or average).
    ///   - formatter: Optional custom formatter for the resulting value.
    ///   - completion: Called on the main thread with the formatted result string.
    func fetchAggregatedValue(in range: (startDate: Date, endDate: Date),
                              for type: HKQuantityTypeIdentifier,
                              unit: HKUnit,
                              aggregation: Aggregation = .sum,
                              formatter: ((Double) -> String)? = nil,
                              completion: @escaping (String) -> Void) {
        fetchSamples(in: range, for: type, unit: unit) { result in
            switch result {
            case .failure:
                completion("--")
            case .success(let samples):
                let values = samples.map { $0.value }
                let aggregated: Double
                switch aggregation {
                case .sum:
                    aggregated = values.reduce(0, +)
                case .average:
                    aggregated = values.isEmpty ? 0 : values.reduce(0, +) / Double(values.count)
                case .min:
                    aggregated = values.min() ?? 0
                case .max:
                    aggregated = values.max() ?? 0
                }
                if let formatter = formatter {
                    completion(formatter(aggregated))
                } else {
                    completion(String(format: "%.2f", aggregated))
                }
            }
        }
    }

    /// Convenience: Fetch samples for the last 7 days (from now - 7 days to now).
    func fetchLast7DaysSamples(for type: HKQuantityTypeIdentifier,
                               unit: HKUnit,
                               limit: Int = HKObjectQueryNoLimit,
                               completion: @escaping (Result<[(date: Date, value: Double)], Error>) -> Void) {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate) ?? endDate.addingTimeInterval(-7 * 24 * 60 * 60)
        fetchSamples(in: (startDate, endDate), for: type, unit: unit, limit: limit, completion: completion)
    }

    /// Convenience: Fetch aggregated value over the last 7 days.
    func fetchLast7DaysAggregatedValue(for type: HKQuantityTypeIdentifier,
                                       unit: HKUnit,
                                       aggregation: Aggregation = .sum,
                                       formatter: ((Double) -> String)? = nil,
                                       completion: @escaping (String) -> Void) {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate) ?? endDate.addingTimeInterval(-7 * 24 * 60 * 60)
        fetchAggregatedValue(in: (startDate, endDate), for: type, unit: unit, aggregation: aggregation, formatter: formatter, completion: completion)
    }

    enum Aggregation {
        case sum
        case average
        case min
        case max
    }
}
