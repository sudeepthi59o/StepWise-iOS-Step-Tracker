//
//  SettingsModel.swift
//  StepsTrackerApp
//
//  Created by Sudeepthi Rebbalapalli on 4/27/25.
//

import Foundation
import UIKit

class SettingsModel {
    
    var toggleOn = false
    var dailyStepGoal: Int
    var selectedUnits = "kms"
    
    init(toggleOn: Bool = false, dailyStepGoal: Int) {
        self.toggleOn = toggleOn
        self.dailyStepGoal = 5000
    }
    
    func checkIfValidGoal() -> Bool {
        //Check if dailyStepGoal is valid
        return true
    }
    
    func checkIfValidUnits() -> Bool {
        //Check if units are kms or miles
        return true
    }
    
    func deleteHistory() {
        //Deletes all the stored step data
    }
    
}
