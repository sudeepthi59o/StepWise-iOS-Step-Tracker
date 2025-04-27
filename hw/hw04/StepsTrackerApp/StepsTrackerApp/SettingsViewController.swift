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
        //TODO
    }
    
    @IBAction func stepsSubmitButton(_ sender: Any) {
        //TODO

    }
    
    
    @IBAction func unitsSubmitButton(_ sender: Any) {
        //TODO

    }
    
    @IBAction func selectUnitsButton(_ sender: Any) {
        //TODO

    }
    
    @IBAction func resetHistoryButton(_ sender: Any) {
        //TODO

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
