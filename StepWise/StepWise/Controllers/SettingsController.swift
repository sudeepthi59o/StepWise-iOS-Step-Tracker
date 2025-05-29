//
//  SettingsController.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//
//

import Foundation
import CoreData
import UserNotifications

class SettingsController: ObservableObject {
    
    private let context: NSManagedObjectContext
    
    @Published var notificationStatusMessage: String? = nil
    
    @Published var toggleOn: Bool {
        didSet {
            UserDefaults.standard.set(toggleOn, forKey: "toggleOn")
            handleNotificationToggleChange()
        }
    }
    
    @Published var dailyStepGoal: Int = 0
    
    
    @Published var selectedUnits: String {
        didSet {
            if selectedUnits != oldValue {
                UserDefaults.standard.set(selectedUnits, forKey: "selectedUnits")
            }
        }
    }
    
    private var previousUnits: String
    
    init(context: NSManagedObjectContext) {
        self.context=context
        if UserDefaults.standard.object(forKey: "toggleOn") == nil {
            self.toggleOn = true
            UserDefaults.standard.set(true, forKey: "toggleOn")
        } else {
            self.toggleOn = UserDefaults.standard.bool(forKey: "toggleOn")
        }
        self.dailyStepGoal = UserDefaults.standard.integer(forKey: "dailyStepGoal")
        let units = UserDefaults.standard.string(forKey: "selectedUnits") ?? "kms"
        self.selectedUnits = units
        self.previousUnits = units
    }
    
    
    func handleNotificationToggleChange() {
        if toggleOn {
            enableNotifications()
            showTemporaryStatusMessage("Notifications Enabled")
        } else {
            disableNotifications()
            showTemporaryStatusMessage("Notifications Disabled")
        }
    }
    
    private func showTemporaryStatusMessage(_ message: String) {
        notificationStatusMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.notificationStatusMessage = nil
        }
    }
    
    
    private func enableNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Notifications Enabled"
                content.body = "You will now receive daily reminders."
                content.sound = .default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: "notificationEnabled", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    private func disableNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Notifications Disabled"
        content.body = "You will no longer receive daily reminders."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notificationDisabled", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func submitUnitsIfChanged() {
        if previousUnits != selectedUnits {
            previousUnits = selectedUnits // update tracker
            showTemporaryStatusMessage("Units updated to \(selectedUnits.capitalized)")
        }
    }
    
    func submitGoal() {
        UserDefaults.standard.set(dailyStepGoal, forKey: "dailyStepGoal")
        showTemporaryStatusMessage("Goal updated successfully!")
    }
    
    
    
    func checkIfValidGoal() -> Bool {
        return self.dailyStepGoal >= 1000 && self.dailyStepGoal <= 15000
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
            UserDefaults.standard.set(false, forKey: "hasInsertedFakeSteps")
        } catch {
            print("Failed to delete history: \(error)")
        }
    }
    
}
