//
//  SettingsController.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//
//

import Foundation
import CoreData

class SettingsController: ObservableObject {
    
    private let context: NSManagedObjectContext
    
    @Published var toggleOn: Bool {
        didSet { UserDefaults.standard.set(toggleOn, forKey: "toggleOn") }
    }
    
    @Published var dailyStepGoal: Int {
        didSet { UserDefaults.standard.set(dailyStepGoal, forKey: "dailyStepGoal") }
    }
    
    @Published var selectedUnits: String {
        didSet { UserDefaults.standard.set(selectedUnits, forKey: "selectedUnits") }
    }
    
    init(context: NSManagedObjectContext) {
        self.context=context
        self.toggleOn = UserDefaults.standard.bool(forKey: "toggleOn")
        self.dailyStepGoal = UserDefaults.standard.integer(forKey: "dailyStepGoal")
        self.selectedUnits = UserDefaults.standard.string(forKey: "selectedUnits") ?? "kms"
    }
    
    func checkIfValidGoal() -> Bool {
        return self.dailyStepGoal >= 1000 && self.dailyStepGoal <= 100000
    }
    
    func checkIfValidUnits() -> Bool {
        let validUnits = ["kms", "miles"]
        return validUnits.contains(self.selectedUnits.lowercased())
    }
    
    func deleteHistory() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = StepDataEntry.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.context.execute(batchDeleteRequest)
            try self.context.save()
            print("History cleared.")
        } catch {
            print("Failed to delete history: \(error)")
        }
    }
    
}
