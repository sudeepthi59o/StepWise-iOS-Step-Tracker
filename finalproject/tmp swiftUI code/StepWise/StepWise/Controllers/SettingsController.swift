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
    
    @Published var toggleOn: Bool {
            didSet {
                UserDefaults.standard.set(toggleOn, forKey: "toggleOn")
                handleNotificationToggleChange()
            }
        }
        
    
    func handleNotificationToggleChange() {
            if toggleOn {
                enableNotifications()
            } else {
                disableNotifications()
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
    
    
    
    @Published var dailyStepGoal: Int {
        didSet { UserDefaults.standard.set(dailyStepGoal, forKey: "dailyStepGoal") }
    }
    
    @Published var selectedUnits: String {
        didSet { UserDefaults.standard.set(selectedUnits, forKey: "selectedUnits") }
    }
    
    init(context: NSManagedObjectContext) {
        self.context=context
        if UserDefaults.standard.object(forKey: "toggleOn") == nil {
                self.toggleOn = true
                UserDefaults.standard.set(true, forKey: "toggleOn")
            } else {
                self.toggleOn = UserDefaults.standard.bool(forKey: "toggleOn")
            }
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
            UserDefaults.standard.set(false, forKey: "hasInsertedFakeSteps")
        } catch {
            print("Failed to delete history: \(error)")
        }
    }
    
}
