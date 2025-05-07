//
//  StepHistoryController.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//
//

import Foundation
import CoreData

class StepHistoryController: ObservableObject {
    
    private let context: NSManagedObjectContext
    private let calendar = Calendar.current
    private let formatter: DateFormatter
    private let fakeDataKey = "hasInsertedFakeSteps"
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.formatter = DateFormatter()
        self.createAndSaveFakeStepData()  //For display purposes we add some fake data
    }
    
    func generateChartData(for period: TimePeriod) -> [ChartEntry] {
        print("Generating chart data for: \(period)")
        let entries = fetchStepData(for: period)
        print("Fetched \(entries.count) entries")
        
        switch period {
        case .daily:
            formatter.dateFormat = "ha" // 1PM, 2PM...
            let grouped = Dictionary(grouping: entries) {
                let date = $0.date ?? Date()
                return calendar.date(bySetting: .minute, value: 0, of: date)!
            }
            
            print("Grouped daily entries: \(grouped.count) groups")
            
            return grouped.sorted { $0.key < $1.key }.map { (date, group) in
                let label = formatter.string(from: date)
                let total = group.reduce(0) { $0 + Int($1.stepCount) }
                
                print("Daily - \(label): \(total) steps")
                return ChartEntry(label: label, stepCount: total)
            }
            
            
        case .weekly:
            formatter.dateFormat = "EEE" // Mon, Tue...
            let grouped = Dictionary(grouping: entries) {
                calendar.startOfDay(for: $0.date ?? Date())
            }
            
            print("Grouped weekly entries: \(grouped.count) groups")
            
            return grouped.sorted { $0.key < $1.key }.map { (date, group) in
                let label = formatter.string(from: date)
                let total = group.reduce(0) { $0 + Int($1.stepCount) }
                
                print("Weekly - \(label): \(total) steps")
                return ChartEntry(label: label, stepCount: total)
            }
            
        case .monthly:
            formatter.dateFormat = "MMM d" // Jan 1, Jan 2...
            let grouped = Dictionary(grouping: entries) {
                calendar.startOfDay(for: $0.date ?? Date())
            }
            
            print("Grouped weekly entries: \(grouped.count) groups")
            
            return grouped.sorted { $0.key < $1.key }.map { (date, group) in
                let label = formatter.string(from: date)
                let total = group.reduce(0) { $0 + Int($1.stepCount) }
                
                
                print("Monthly - \(label): \(total) steps")
                return ChartEntry(label: label, stepCount: total)
            }
        }
    }
    
    private func fetchStepData(for period: TimePeriod) -> [StepDataEntry] {
        let fetchRequest: NSFetchRequest<StepDataEntry> = StepDataEntry.fetchRequest()
        let now = Date()
        
        switch period {
        case .daily:
            let start = calendar.startOfDay(for: now)
            let end = calendar.date(byAdding: .day, value: 1, to: start)!
            fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
            
            print("Fetching daily data from \(start) to \(end)")
            
        case .weekly:
            let start = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now))!
            let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!
            fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
            
            print("Fetching weekly data from \(start) to \(end)")
            
        case .monthly:
            let start = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: now))!
            let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!
            fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
            
            print("Fetching montly data from \(start) to \(end)")
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            print("Fetched \(results.count) records from Core Data")
            return results
        } catch {
            print("Fetch failed: \(error)")
            return []
        }
    }
    
    
    private func createAndSaveFakeStepData() -> Void {
        if UserDefaults.standard.bool(forKey: fakeDataKey) {
            print("Fake data already inserted")
            return
        }
        
        print("Inserting fake step data")
        var entries: [StepDataEntry] = []
        let now = Date()
        
        for dayOffset in 1...30 {
            let entry = StepDataEntry(context: context)
            entry.date = calendar.date(byAdding: .day, value: -dayOffset, to: now)
            entry.stepCount = Int16(Int.random(in: 3000...12000))
            entry.kmsWalked = StepDataModel.calculateDistance(steps:Int(entry.stepCount))
            entry.caloriesBurnt = StepDataModel.calculateCalories(steps: Int(entry.stepCount))
            entries.append(entry)
            print("Inserted fake entry for \(formatter.string(from: entry.date!)): \(entry.stepCount) steps")
        }
        
        do {
            try context.save()
            UserDefaults.standard.set(true, forKey: fakeDataKey)
            print("Fake data saved successfully")
        } catch {
            print("Save failed: \(error)")
        }
        
    }
    
    
    
}
