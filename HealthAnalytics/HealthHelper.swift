//
//  HealthHelper.swift
//  HealthAnalytics
//
//  Created by Govila, Dhruv on 25/09/2022.
//

import Foundation
import HealthKit
class HealthHelper {
    static let shared: HealthHelper = .init()
    
    private init() {}
    
    let healthStore = HKHealthStore()
    let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! ]
    
    func askAuthorization(_ completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (status, error) in
            if status {
                print("Health Permission Status: \(status)")
            } else {
                print("Error: \(error)")
            }
            completion(status)
        }
    }
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date.now
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: Date.now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: stepsQuantityType,
            quantitySamplePredicate: predicate,
            options: .  cumulativeSum
        ) { statisticsQuery, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        healthStore.execute(query)
    }
}
