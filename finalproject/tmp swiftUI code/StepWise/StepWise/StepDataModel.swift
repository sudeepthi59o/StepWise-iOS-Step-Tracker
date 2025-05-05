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
    
    @Published var stepCount = 0
    @Published var distance = 0.0
    @Published var calories = 0.0
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // Start step tracking
    func startTrackingSteps() {
       
        self.isStepCountingAvailable()
        
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                self.stepCount = data.numberOfSteps.intValue
                self.distance = self.calculateDistance(steps: self.stepCount)
                self.calories = self.calculateCalories(steps: self.stepCount)
                
            }
        }
    }
    
    // Stop step tracking
    func stopTrackingSteps() {
        pedometer.stopUpdates()
        
        // Save step data to Core Data
        self.saveStepData()
    }
    
    private func calculateDistance(steps: Int) -> Double {
        return Double(steps) * 0.000762 // 0.000762 km per step
    }
    
    private func calculateCalories(steps: Int) -> Double {
        return Double(steps) * 0.04 // 0.04 calories per step
    }
    
    // Save the current step data to Core Data
    func saveStepData() {
        let newStepDataEntry = StepDataEntry(context: context)
        newStepDataEntry.date = Date()
        newStepDataEntry.stepCount = Int16(stepCount)
        newStepDataEntry.kmsWalked = self.distance
        newStepDataEntry.caloriesBurnt = self.calories
        
        // Save the context to persist data
        do {
            try context.save()
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
