//
//  SettingsViewController.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 04/30/25
//
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var enableDailyReminderLabel: UILabel!
    @IBOutlet weak var dailyStepGoalLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var dailyStepCountGoal: UITextField!
    
    @IBAction func toggleReminderButton(_ sender: Any) {
        //Modify the value of the SettingsModel.toggleOn
        //This is a toggle button
    }
    
    @IBAction func stepsSubmitButton(_ sender: Any) {
        // Validate and retrieve the daily step goal from the text field
        guard let goalText = dailyStepCountGoal.text,
              let goal = Int(goalText), goal > 0 else {
            print("Invalid step goal")
            return
        }

        // Save the step goal to the Core Data model
        saveGoalToCoreData(goal: goal)
        
        // Fetch and print saved goals after submitting
        fetchGoals()  // Call fetchGoals to verify if the goal is saved correctly

        // Optionally, update the SettingsModel
        let settingsModel = SettingsModel(dailyStepGoal: goal)
        
        print("Step goal saved: \(goal)")
    }
    
    func fetchGoals() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for StepEntry entity
        let fetchRequest: NSFetchRequest<UserStepEntry> = UserStepEntry.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            for goal in results {
                print("Saved Goal Count: \(goal.goalCount), Date: \(goal.date ?? Date())")
            }
        } catch {
            print("Failed to fetch goals: \(error)")
        }
    }


        
        func saveGoalToCoreData(goal: Int) {
            // Get the Core Data context
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            
            // Create a new StepEntry entity and set the goalCount
            let entity = NSEntityDescription.entity(forEntityName: "UserStepEntry", in: context)!
            let stepEntry = NSManagedObject(entity: entity, insertInto: context)
            
            stepEntry.setValue(goal, forKey: "goalCount") // save goalCount to Core Data
            stepEntry.setValue(Date(), forKey: "date") // Optionally, save the current date
            
            // Save to Core Data
            do {
                try context.save()
                print("Goal saved successfully to Core Data")
            } catch {
                print("Failed to save goal: \(error)")
            }
        }
        
    
    @IBAction func unitsSubmitButton(_ sender: Any) {
        //Modify the value of the SettingsModel.selectedUnits

    }
    
    @IBAction func selectUnitsButton(_ sender: Any) {
        //Select the preferred units for distance

    }
    
    @IBAction func resetHistoryButton(_ sender: Any) {
        //Clear the persistent storage/historical records

    }
    override func viewDidLoad() {
        
        self.settingsLabel.text="Settings"

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
