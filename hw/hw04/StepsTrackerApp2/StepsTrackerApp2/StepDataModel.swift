//
//  StepDataModel.swift
//  StepsTrackerApp
//
//  Created by Sudeepthi Rebbalapalli on 4/27/25.
//

import Foundation
import UIKit
import CoreMotion
import CoreData

class StepDataModel {
    
    let pedometer = CMPedometer()
    var managedContext: NSManagedObjectContext!
    
    
    func startTrackingSteps(onUpdate: @escaping (Int, Double, Double) -> Void, onError: @escaping (Error) -> Void) {
        
        self.pedometer.startUpdates(from: Date()) { [weak self] pedometerData, error in
            
            guard let self = self else { return }
            
            if let error = error {
                onError(error)
                return
            }
            
            if let steps = pedometerData?.numberOfSteps {
                
                guard let pedometerData = pedometerData else {
                    print("Pedometer data is nil")
                    return
                }
                
                let stepInt = steps.intValue
                let distance = self.calculateDistanceTravelled(steps: stepInt)
                let calories = self.calculateCaloriesBurnt(steps: stepInt)
                
                onUpdate(stepInt, distance, calories)
                
            } else {
                print("No step data received.")
            }
        }
    }
    
    func stopTrackingSteps(stepLabelText: String, onCompletion: @escaping (Int, Double, Double) -> Void){
        
        self.pedometer.stopUpdates()
        
        guard let steps = Int(stepLabelText) else {
                    print("Failed to parse steps from label")
                    return
                }
                
        let distance = calculateDistanceTravelled(steps: steps)
        let calories = calculateCaloriesBurnt(steps: steps)
        
        onCompletion(steps,distance,calories)
    
        print("Attempting to save step data...")
        // Save the step data to Core Data
        self.saveStepData(stepsCount: steps, date: Date(), distance: distance, calories: calories)
        
        self.fetchStepEntries()
    }
    
    // Estimate distance (e.g., 0.000762 kilometers per step for an average person)
    func calculateDistanceTravelled(steps: Int) -> Double{
        return Double(steps) * 0.000762
    }
    
    // Estimate calories burned (e.g., 0.04 calories per step for an average person)
    func calculateCaloriesBurnt(steps: Int)  -> Double {
        return Double(steps) * 0.04
    }
    
    
    func saveStepData(stepsCount: Int, date: Date, distance: Double, calories: Double) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Failed to get AppDelegate")
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a new UserStepEntry entity object
        let stepEntry = UserStepEntry(context: managedContext)
        stepEntry.stepCount = Int16(stepsCount)
        stepEntry.date = date
        stepEntry.kmsWalked = distance
        stepEntry.calories = calories
        
        do {
            try managedContext.save()
            print("Step data saved successfully!")
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    //Read saved data from persistent storage
    func fetchStepEntries() {
        let fetchRequest: NSFetchRequest<UserStepEntry> = UserStepEntry.fetchRequest()
        
        do {
            let entries = try managedContext.fetch(fetchRequest)
            for entry in entries {
                print("\(entry.date ?? Date()): \(entry.stepCount) steps, \(entry.kmsWalked) km, \(entry.calories) cal")
            }
        } catch {
            print("Failed to fetch step entries: \(error)")
        }
    }
    
    func isStepCountingAvailable(){
        if CMPedometer.isStepCountingAvailable() {
            print("Step counting is available on this device")
               } else {
                   print("Step counting not available on this device")
               }
        
           }
    
    deinit {
        print("StepDataModel deinitialized — stopping pedometer")
        self.pedometer.stopUpdates()
        }
    }
    
