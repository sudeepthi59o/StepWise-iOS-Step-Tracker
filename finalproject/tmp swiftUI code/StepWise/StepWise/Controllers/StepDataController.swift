//
//  StepDataController.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//
//

import Foundation
import CoreMotion
import CoreData
import UserNotifications

class StepDataController: ObservableObject {
    
    private let pedometer = CMPedometer()
    private let context: NSManagedObjectContext
    private let startTimeKey = "stepTrackingStartTime"
    
    @Published var stepCount = 0
    @Published var distance = 0.0
    @Published var calories = 0.0
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.loadSavedStepsIfNeeded()
        self.recoverUnstoppedSessionIfNeeded()
        self.resetGoalNotificationIfNeeded()
    }
    
    
    func startTrackingSteps() {
        print("Starting step tracking...")
        isStepCountingAvailable()
        
        let now = Date()
        UserDefaults.standard.set(now, forKey: startTimeKey)
        print("Step tracking started at: \(now)")
        
        pedometer.startUpdates(from: now) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else {
                print("Pedometer error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.stepCount = data.numberOfSteps.intValue
                self.distance = StepDataModel.calculateDistance(steps: self.stepCount)
                self.calories = StepDataModel.calculateCalories(steps: self.stepCount)
                
                print("Updated step count: \(self.stepCount), distance: \(self.distance), calories: \(self.calories)")
                
                self.checkAndSendGoalNotification()
                
            }
        }
    }
    
    func stopTrackingSteps() {
        print("Stopping step tracking...")
        pedometer.stopUpdates()
        queryAndSaveStepData()
        UserDefaults.standard.removeObject(forKey: startTimeKey)
        print("Step tracking stopped and data saved.")
    }
    
    private func loadSavedStepsIfNeeded() {
        guard let startTime = UserDefaults.standard.object(forKey: startTimeKey) as? Date else { return }
        print("Loading saved step data from: \(startTime)")
        fetchPedometerData(from: startTime, to: Date())
    }
    
    private func queryAndSaveStepData() {
        guard let startTime = UserDefaults.standard.object(forKey: startTimeKey) as? Date else { return }
        print("Querying and saving step data from: \(startTime) to \(Date())")
        fetchPedometerData(from: startTime, to: Date(), shouldSave: true)
    }
    
    private func fetchPedometerData(from: Date, to: Date, shouldSave: Bool = false) {
        print("Querying pedometer data from \(from) to \(to)")
        pedometer.queryPedometerData(from: from, to: to) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else {
                print("Query error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.stepCount = data.numberOfSteps.intValue
                self.distance = StepDataModel.calculateDistance(steps: self.stepCount)
                self.calories = StepDataModel.calculateCalories(steps: self.stepCount)
                print("Queried step count: \(self.stepCount), distance: \(self.distance), calories: \(self.calories)")
                if shouldSave {
                    self.saveStepData()
                }
            }
        }
    }
    
    func recoverUnstoppedSessionIfNeeded() {
        guard let startDate = UserDefaults.standard.object(forKey: startTimeKey) as? Date else { return }
        print("Recovering unstopped session from \(startDate)")
        
        let calendar = Calendar.current
        if !calendar.isDateInToday(startDate) {
            let endOfDay = calendar.startOfDay(for: Date())
            
            print("Querying pedometer data from \(startDate) to end of day: \(endOfDay)")
            pedometer.queryPedometerData(from: startDate, to: endOfDay) { [weak self] data, error in
                guard let self = self, let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    self.stepCount = data.numberOfSteps.intValue
                    self.distance = StepDataModel.calculateDistance(steps: self.stepCount)
                    self.calories = StepDataModel.calculateCalories(steps: self.stepCount)
                    self.saveStepData()
                    
                    print("Recovered session data: step count: \(self.stepCount), distance: \(self.distance), calories: \(self.calories)")
                    UserDefaults.standard.removeObject(forKey: self.startTimeKey)
                }
            }
        }
    }
    
    
    func saveStepData() {
        print("Saving step data to Core Data...")
        let newStepDataEntry = StepDataEntry(context: context)
        newStepDataEntry.date = Date()
        newStepDataEntry.stepCount = Int16(stepCount)
        newStepDataEntry.kmsWalked = self.distance
        newStepDataEntry.caloriesBurnt = self.calories
        
        do {
            try context.save()
            print("Step data saved successfully.")
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    private func triggerGoalNotification() {
        let content = UNMutableNotificationContent()
        content.title = " Goal Achieved!"
        content.body = "You've reached your step goal for today!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
    
    private func resetGoalNotificationIfNeeded() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDateKey = "lastNotificationDate"
        
        if let lastDate = UserDefaults.standard.object(forKey: lastDateKey) as? Date {
            if !Calendar.current.isDate(today, inSameDayAs: lastDate) {
                UserDefaults.standard.set(false, forKey: "goalNotificationSent")
                UserDefaults.standard.set(today, forKey: lastDateKey)
            }
        } else {
            UserDefaults.standard.set(false, forKey: "goalNotificationSent")
            UserDefaults.standard.set(today, forKey: lastDateKey)
        }
    }
    
    private func checkAndSendGoalNotification() {
        let goal = UserDefaults.standard.integer(forKey: "dailyStepGoal")
        if !UserDefaults.standard.bool(forKey: "goalNotificationSent"),
           stepCount >= goal {
            triggerGoalNotification()
            UserDefaults.standard.set(true, forKey: "goalNotificationSent")
        }
    }
    
    
    
    private func isStepCountingAvailable(){
        if CMPedometer.isStepCountingAvailable() {
            print("Step counting is available on this device")
        } else {
            print("Step counting not available on this device")
        }
        
    }
}
