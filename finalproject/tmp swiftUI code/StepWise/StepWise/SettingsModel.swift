//
//  SettingsModel.swift
//  StepWise
//
//  Created by Sudeepthi Rebbalapalli on 5/4/25.
//

import Foundation

class SettingsModel: ObservableObject {
    @Published var toggleOn: Bool
    @Published var dailyStepGoal: Int
    @Published var selectedUnits: String

    init(toggleOn: Bool = false, dailyStepGoal: Int = 5000, selectedUnits: String = "kms") {
        self.toggleOn = toggleOn
        self.dailyStepGoal = dailyStepGoal
        self.selectedUnits = selectedUnits
    }

    func checkIfValidGoal() -> Bool {
        // Add real logic if needed
        return dailyStepGoal > 0
    }

    func checkIfValidUnits() -> Bool {
        return selectedUnits == "kms" || selectedUnits == "miles"
    }

    func deleteHistory() {
        // Hook into Core Data or other data layer to delete stored step data
        print("History cleared.")
    }
}
