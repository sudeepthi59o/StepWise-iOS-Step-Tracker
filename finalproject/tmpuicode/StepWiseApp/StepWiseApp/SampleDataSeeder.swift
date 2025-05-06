//
//  SampleDataSeeder.swift
//  StepWiseApp
//
//  Created by Rajesh Kumar Reddy Avula on 5/4/25.
//

// SampleDataSeeder.swift

import Foundation
import UIKit
import CoreData
import CoreData
import CoreData

func insertManualStepData() {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let calendar = Calendar.current
    let today = Date()
    
    let entries: [(Date, Int16, Double, Double)] = [
        // Daily
        (today, 6000, 4.5, 250),
        (today, 4000, 3.0, 180),
        // Weekly
        (calendar.date(byAdding: .day, value: -2, to: today)!, 5500, 4.2, 220),
        (calendar.date(byAdding: .day, value: -4, to: today)!, 5200, 3.9, 210),
        // Monthly
        (calendar.date(byAdding: .day, value: -10, to: today)!, 7000, 5.5, 280),
        (calendar.date(byAdding: .day, value: -20, to: today)!, 6500, 5.0, 260)
    ]
    
    for (date, steps, kms, calories) in entries {
        let entry = UserStepEntry(context: context)
        entry.date = date
        entry.stepCount = steps
        entry.kmsWalked = kms
        entry.calories = calories
    }

    do {
        try context.save()
        print("✅ 6 manual entries inserted into Core Data.")
    } catch {
        print("❌ Failed to insert sample data: \(error)")
    }
}

