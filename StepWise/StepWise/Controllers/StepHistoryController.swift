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
        let entries = fetchStepData(for: period)
        
        switch period {
        case .daily:
            formatter.dateFormat = "ha" // 1PM, 2PM...
            let grouped = Dictionary(grouping: entries) {
                let date = $0.date ?? Date()
                return calendar.date(bySetting: .minute, value: 0, of: date)!
            }
            
            return grouped.sorted { $0.key < $1.key }.map { (date, group) in
                let label = formatter.string(from: date)
                let total = group.reduce(0) { $0 + Int($1.stepCount) }
                
                return ChartEntry(label: label, stepCount: total)
            }
            
            
        case .weekly:
            formatter.dateFormat = "EEE" // Mon, Tue...
            let grouped = Dictionary(grouping: entries) {
                calendar.startOfDay(for: $0.date ?? Date())
            }
            
            return grouped.sorted { $0.key < $1.key }.map { (date, group) in
                let label = formatter.string(from: date)
                let total = group.reduce(0) { $0 + Int($1.stepCount) }
                
                return ChartEntry(label: label, stepCount: total)
            }
            
        case .monthly:
            let calendar = Calendar.current
            
            let grouped = Dictionary(grouping: entries) { entry -> String in
                guard let date = entry.date else { return "Week 1" }
                let day = calendar.component(.day, from: date)
                
                switch day {
                case 1...7:
                    return "Week 1"
                case 8...14:
                    return "Week 2"
                case 15...21:
                    return "Week 3"
                case 22...31:
                    return "Week 4"
                default:
                    return "Unknown"
                }
            }
            
            return ["Week 1", "Week 2", "Week 3", "Week 4"].compactMap { week in
                if let group = grouped[week] {
                    let total = group.reduce(0) { $0 + Int($1.stepCount) }
                    return ChartEntry(label: week, stepCount: total)
                } else {
                    return ChartEntry(label: week, stepCount: 0)
                }
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
            
        case .weekly:
            let start = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now))!
            let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!
            fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
            
        case .monthly:
            let start = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: now))!
            let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!
            fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
            
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            return []
        }
    }
    
    
    private func createAndSaveFakeStepData() -> Void {
        if UserDefaults.standard.bool(forKey: fakeDataKey) {
            return
        }
        
        var entries: [StepDataEntry] = []
        let now = Date()
        
        for dayOffset in 1...30 {
            let entry = StepDataEntry(context: context)
            entry.date = calendar.date(byAdding: .day, value: -dayOffset, to: now)
            entry.stepCount = Int16(Int.random(in: 3000...12000))
            entry.kmsWalked = StepDataModel.calculateDistance(steps:Int(entry.stepCount))
            entry.caloriesBurnt = StepDataModel.calculateCalories(steps: Int(entry.stepCount))
            entries.append(entry)
            
        }
        
        do {
            try context.save()
            UserDefaults.standard.set(true, forKey: fakeDataKey)
        } catch {
            print("Save failed: \(error)")
        }
        
    }
    
    
    
}
