//
//  StepHistoryModel.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 04/30/25
//
//

import Foundation
import UIKit
import CoreData

class StepHistoryModel {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private func fetchEntries(from startDate: Date, to endDate: Date) -> [UserStepEntry] {
        let fetchRequest: NSFetchRequest<UserStepEntry> = UserStepEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }

    func fetchDailyStepData() -> [UserStepEntry] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        return fetchEntries(from: startOfDay, to: endOfDay)
    }

    func fetchWeeklyStepData() -> [UserStepEntry] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
        return fetchEntries(from: startOfWeek, to: endOfWeek)
    }

    func fetchMonthlyData() -> [UserStepEntry] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let endOfMonth = calendar.date(byAdding: .day, value: range.count, to: startOfMonth)!
        return fetchEntries(from: startOfMonth, to: endOfMonth)
    }
}
