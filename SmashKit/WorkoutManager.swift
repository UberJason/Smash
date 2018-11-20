//
//  WorkoutManager.swift
//  SmashWatch Extension
//
//  Created by Jason Ji on 11/17/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import HealthKit

public class WorkoutManager: NSObject {
    public static let shared = WorkoutManager()
    
    private let healthStore: HKHealthStore
    
    #if os(watchOS)
    private var workoutDataSource: HKLiveWorkoutDataSource?
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    #endif
    
    private override init() {
        healthStore = HKHealthStore()
    }
    
    public func requestHealthKitAuthorization(_ completion: (() -> ())? = nil) {
        if HKHealthStore.isHealthDataAvailable() {
            let typesToShare: Set = [
                                        HKQuantityType.workoutType()
                                    ]
            let typesToRead: Set = [
                                    HKObjectType.quantityType(forIdentifier: .heartRate)!,
                                    HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
                                ]
            healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (result, error) in
                if result {
                    completion?()
                }
            }
        }
    }
    
    #if os(watchOS)
    
    public func startOrResumeWorkout() {
        guard let session = self.session else { startWorkout(); return }
        
        switch session.state {
        case .notStarted, .prepared:
            startWorkout()
        case .paused:
            resumeWorkout()
        case .running, .ended, .stopped:
            break
        }
    }
    
    public func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .tableTennis
        configuration.locationType = .indoor
        
        session = try! HKWorkoutSession(healthStore: healthStore, configuration: configuration)
        session?.delegate = self
        builder = session?.associatedWorkoutBuilder()
        
        workoutDataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
        builder?.delegate = self
        builder?.dataSource = workoutDataSource
        
        session?.startActivity(with: Date())
        builder?.beginCollection(withStart: Date()) { (_, _) in }
    }
    
    public func pauseWorkout() {
        session?.pause()
    }
    
    public func resumeWorkout() {
        session?.resume()
    }
    
    public func endWorkout() {
        session?.end()
        builder?.endCollection(withEnd: Date()) { (_, _) in
            self.builder?.finishWorkout { (_, _) in }
        }
        
    }
    
    public var calories: Double {
        guard let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned),
            let calorieQuantity = builder?.statistics(for: calorieType)?.sumQuantity() else { return -1.0 }
        
        return calorieQuantity.doubleValue(for: HKUnit.kilocalorie())
    }
    
    public var elapsedTime: TimeInterval {
        guard let builder = builder else { return 0.0 }
        return builder.elapsedTime
    }
    
    public var heartRate: Int {
        guard let hrType = HKQuantityType.quantityType(forIdentifier: .heartRate),
            let hrQuantity = builder?.statistics(for: hrType)?.mostRecentQuantity() else { return -1 }
        
        let hrUnit = HKUnit(from: "count/min")
        return Int(hrQuantity.doubleValue(for: hrUnit))
    }
    #endif
}

#if os(watchOS)
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    public func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        print("workoutBuilder:didCollectDataOf: \(collectedTypes)")
        
        guard let hrType = HKQuantityType.quantityType(forIdentifier: .heartRate),
            let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
                return
        }
        
        if collectedTypes.contains(hrType) {
            if let hrQuantity = workoutBuilder.statistics(for: hrType)?.mostRecentQuantity() {
                // We want to have BPM
                let hrUnit = HKUnit(from: "count/min")
                let hr = Int(hrQuantity.doubleValue(for: hrUnit))
                
                print("HR: \(hr)")
            }
        }
        
        if collectedTypes.contains(calorieType) {
            if let calorieQuantity = workoutBuilder.statistics(for: calorieType)?.sumQuantity() {
                let value = calorieQuantity.doubleValue(for: HKUnit.kilocalorie())
                
                print("Calories: \(value) kcal")
            }
        }
        
    }
    
    public func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        print("workoutBuilderDidCollectEvent:")
    }
}

extension WorkoutManager: HKWorkoutSessionDelegate {
    public func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("workoutSession:didChange: \(toState)")
    }
    
    public func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("workoutSession:didFail: \(error.localizedDescription)")
    }
}
#endif
