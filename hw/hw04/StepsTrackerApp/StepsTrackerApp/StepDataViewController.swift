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
        self.numOfStepsLabel.text = "0"
        self.stepCounterLabel.text = "Steps: 0"
        self.kmsWalkedLabel.text = "0.00 km"
        self.caloriesBurntLabel.text = "0.00 cal"

        self.pedometer.startUpdates(from: Date()) { [weak self] pedometerData, error in
            guard let self = self else { return }

            if let error = error {
                print("Pedometer error: \(error.localizedDescription)")
                return
            }

            if let steps = pedometerData?.numberOfSteps {
                let stepInt = steps.intValue
                let distance = Double(stepInt) * 0.000762 // km
                let calories = Double(stepInt) * 0.04     // estimated

                DispatchQueue.main.async {
                    self.numOfStepsLabel.text = "\(stepInt)"
                    self.stepCounterLabel.text = "Steps: \(stepInt)"
                    self.kmsWalkedLabel.text = String(format: "%.2f km", distance)
                    self.caloriesBurntLabel.text = String(format: "%.2f cal", calories)
                }
            }
        }
    }

    
    @IBAction func stopTaskButton(_ sender: Any) {
        self.pedometer.stopUpdates()
        
        guard let steps = Int(self.numOfStepsLabel.text ?? "0") else { return }
                
        // Estimate distance (e.g., 0.000762 meters per step for an average person)
        let distance = Double(steps) * 0.000762 // in kilometers
                
        // Estimate calories burned (e.g., 0.04 calories per step for an average person)
        let calories = Double(steps) * 0.04
                
        // Save the step data to Core Data
        saveStepData(stepsCount: steps, date: Date(), distance: distance, calories: calories)
                
                // Update the UI with estimated distance and calories
//                self.kmsWalkedLabel.text = String(format: "%.2f km", distance)
//                self.caloriesBurntLabel.text = String(format: "%.2f cal", calories)
        
        
    }
    
    func saveStepData(stepsCount: Int, date: Date, distance: Double, calories: Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a new StepEntry entity object
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


    
    
    override func viewDidLoad() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = appDelegate.managedContext
        
        self.stepCounterLabel.text="Step Counter"
        
        self.numOfStepsLabel.text = "0"
        
        if CMPedometer.isStepCountingAvailable() {
            print("Step counting is available on this device")
               } else {
                   print("Step counting not available on this device")
               }
           }


    deinit {
        self.pedometer.stopUpdates()
        }
    }


