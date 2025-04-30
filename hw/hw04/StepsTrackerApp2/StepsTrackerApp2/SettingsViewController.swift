//
//  SettingsViewController.swift
//  StepsTrackerApp
//
//  Created by Sudeepthi Rebbalapalli on 4/27/25.
//

import UIKit

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
        //Modify the value of the SettingsModel.dailyStepGoal

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
