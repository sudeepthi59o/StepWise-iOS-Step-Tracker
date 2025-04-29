//
//  StepDataViewController.swift
//  StepsTrackerApp
//
//  Created by Sudeepthi Rebbalapalli on 4/27/25.
//

import UIKit
import CoreMotion
import CoreData

class StepDataViewController: UIViewController {
    
    let pedometer = CMPedometer()
    var managedContext: NSManagedObjectContext!

    @IBOutlet weak var stepCounterLabel: UILabel!
    @IBOutlet weak var numOfStepsLabel: UILabel!
    @IBOutlet weak var kmsWalkedLabel: UILabel!
    @IBOutlet weak var caloriesBurntLabel: UILabel!
    
    
    @IBAction func startTaskButton(_ sender: Any) {
        
        print("startTaskButton tapped")
        
        self.numOfStepsLabel.text = "0"
        self.kmsWalkedLabel.text = "0.00 km"
        self.caloriesBurntLabel.text = "0.00 cal"
        
        
        self.pedometer.startUpdates(from: Date()) { [weak self] pedometerData, error in
            
            guard let self = self else { return }
            
            if let error = error {
                print("Pedometer error: \(error.localizedDescription)")
                return
            }
            
            if let steps = pedometerData?.numberOfSteps {
                
                guard let pedometerData = pedometerData else {
                        print("Pedometer data is nil")
                        return
                    }
                    
                    let stepsInt = pedometerData.numberOfSteps.intValue
                    let distance = Double(stepsInt) * 0.000762
                    let calories = Double(stepsInt) * 0.04
                
                DispatchQueue.main.async {
                    self.numOfStepsLabel.text = "\(steps)"
                    self.kmsWalkedLabel.text = String(format: "%.2f km", distance)
                    self.caloriesBurntLabel.text = String(format: "%.2f cal", calories)
                }
            } else {
                print("No step data received.")
            }
        }
    }

    
    @IBAction func stopTaskButton(_ sender: Any) {
        
        print("stopTaskButton tapped")
        
        self.pedometer.stopUpdates()
        
        guard let steps = Int(self.numOfStepsLabel.text ?? "0") else {
                    print("Failed to parse steps from label")
                    return
                }
                
        // Estimate distance (e.g., 0.000762 kilometers per step for an average person)
        let distance = Double(steps) * 0.000762 // in kilometers
                
        // Estimate calories burned (e.g., 0.04 calories per step for an average person)
        let calories = Double(steps) * 0.04
        
        print("Stopping task with steps: \(steps), distance: \(distance), calories: \(calories)")

    
        print("Attempting to save step data...")
        // Save the step data to Core Data
        saveStepData(stepsCount: steps, date: Date(), distance: distance, calories: calories)
        
        self.fetchStepEntries()
        
    }
    
    func saveStepData(stepsCount: Int, date: Date, distance: Double, calories: Double) {
                
        // Create a new UserStepEntry entity object
        let stepEntry = UserstepEntry(context: managedContext)
        stepEntry.stepCount = Int16(stepsCount)
        stepEntry.date = date
        stepEntry.kmsWalked = distance
        stepEntry.calories = calories
        
        do {
            try managedContext.save()
            print("Step data saved successfully!")
            
            DispatchQueue.main.async {
                self.kmsWalkedLabel.text = String(format: "%.2f km", distance)
                self.caloriesBurntLabel.text = String(format: "%.2f cal", calories)
            }
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //Read saved data
    func fetchStepEntries() {
        let fetchRequest: NSFetchRequest<UserstepEntry> = UserstepEntry.fetchRequest()
        
        do {
            let entries = try managedContext.fetch(fetchRequest)
            for entry in entries {
                print("\(entry.date ?? Date()): \(entry.stepCount) steps, \(entry.kmsWalked) km, \(entry.calories) cal")
            }
        } catch {
            print("Failed to fetch step entries: \(error)")
        }
    }

    
    override func viewDidLoad() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    print("Failed to get AppDelegate")
                    return
                }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        self.stepCounterLabel.text="Step Counter"
        
        self.numOfStepsLabel.text = "0"
        
        if CMPedometer.isStepCountingAvailable() {
            print("Step counting is available on this device")
               } else {
                   print("Step counting not available on this device")
               }
           }
    


    deinit {
        print("StepDataViewController deinitialized — stopping pedometer")
        self.pedometer.stopUpdates()
        }
    }


