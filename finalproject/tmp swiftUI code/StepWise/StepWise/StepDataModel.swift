//
//  StepDataModel.swift
//  StepWise
//
//  Created by Sudeepthi Rebbalapalli on 5/4/25.
//

import Foundation
import CoreMotion
import CoreData

class StepDataModel: ObservableObject {
    
    private let pedometer = CMPedometer()
    private let context: NSManagedObjectContext
    private let startTimeKey = "stepTrackingStartTime"
    
    @Published var stepCount = 0
    @Published var distance = 0.0
    @Published var calories = 0.0
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.loadSavedStepsIfNeeded()
        self.recoverUnstoppedSessionIfNeeded()
    }
    
    
    // Start step tracking
    func startTrackingSteps() {
        print("Starting step tracking...")
        self.isStepCountingAvailable()
        
        let now = Date()
        UserDefaults.standard.set(now, forKey: startTimeKey)
        print("Step tracking started at: \(now)")
        
        pedometer.startUpdates(from: now) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else {
                print("Pedometer error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.stepCount = data.numberOfSteps.intValue
                self.distance = self.calculateDistance(steps: self.stepCount)
                self.calories = self.calculateCalories(steps: self.stepCount)
                
                print("Updated step count: \(self.stepCount), distance: \(self.distance), calories: \(self.calories)")
            }
        }
    }
    
    func stopTrackingSteps() {
        print("Stopping step tracking...")
        self.pedometer.stopUpdates()
        self.queryAndSaveStepData()
        UserDefaults.standard.removeObject(forKey: startTimeKey)
        print("Step tracking stopped and data saved.")
    }
    
    private func calculateDistance(steps: Int) -> Double {
        return Double(steps) * 0.000762 // 0.000762 km per step
    }
    
    private func calculateCalories(steps: Int) -> Double {
        return Double(steps) * 0.04 // 0.04 calories per step
    }
    
    private func loadSavedStepsIfNeeded() {
        guard let startTime = UserDefaults.standard.object(forKey: startTimeKey) as? Date else { return }
        print("Loading saved step data from: \(startTime)")
        self.fetchPedometerData(from: startTime, to: Date())
    }
    
    private func queryAndSaveStepData() {
        guard let startTime = UserDefaults.standard.object(forKey: startTimeKey) as? Date else { return }
        print("Querying and saving step data from: \(startTime) to \(Date())")
        self.fetchPedometerData(from: startTime, to: Date(), shouldSave: true)
    }
    
    private func fetchPedometerData(from: Date, to: Date, shouldSave: Bool = false) {
        print("Querying pedometer data from \(from) to \(to)")
        self.pedometer.queryPedometerData(from: from, to: to) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else {
                print("Query error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.stepCount = data.numberOfSteps.intValue
                self.distance = self.calculateDistance(steps: self.stepCount)
                self.calories = self.calculateCalories(steps: self.stepCount)
                print("Queried step count: \(self.stepCount), distance: \(self.distance), calories: \(self.calories)")
                if shouldSave {
                    self.saveStepData()
                }
            }
        }
    }
    
    func recoverUnstoppedSessionIfNeeded() {
        guard let startDate = UserDefaults.standard.object(forKey: startTimeKey) as? Date else { return }
        print("Recovering unstopped session from \(startDate)")
        
        let calendar = Calendar.current
        if !calendar.isDateInToday(startDate) {
            let endOfDay = calendar.startOfDay(for: Date())
            
            print("Querying pedometer data from \(startDate) to end of day: \(endOfDay)")
            pedometer.queryPedometerData(from: startDate, to: endOfDay) { [weak self] data, error in
                guard let self = self, let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    self.stepCount = data.numberOfSteps.intValue
                    self.distance = self.calculateDistance(steps: self.stepCount)
                    self.calories = self.calculateCalories(steps: self.stepCount)
                    self.saveStepData()
                    
                    print("Recovered session data: step count: \(self.stepCount), distance: \(self.distance), calories: \(self.calories)")  // Debug
                    UserDefaults.standard.removeObject(forKey: self.startTimeKey)
                }
            }
        }
    }
    
    
    // Save the current step data to Core Data
    func saveStepData() {
        print("Saving step data to Core Data...")
        let newStepDataEntry = StepDataEntry(context: context)
        newStepDataEntry.date = Date()
        newStepDataEntry.stepCount = Int16(stepCount)
        newStepDataEntry.kmsWalked = self.distance
        newStepDataEntry.caloriesBurnt = self.calories
        
        // Save the context to persist data
        do {
            try context.save()
            print("Step data saved successfully.")
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    func isStepCountingAvailable(){
        if CMPedometer.isStepCountingAvailable() {
            print("Step counting is available on this device")
        } else {
            print("Step counting not available on this device")
        }
        
    }
}
