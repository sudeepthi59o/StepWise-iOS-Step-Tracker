//
//  StepEntry+CoreDataProperties.swift
//  StepsTrackerApp
//
//  Created by Sudeepthi Rebbalapalli on 4/27/25.
//
//

import Foundation
import CoreData


extension StepEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepEntry> {
        return NSFetchRequest<StepEntry>(entityName: "StepEntry")
    }

    @NSManaged public var calories: Double
    @NSManaged public var date: Date?
    @NSManaged public var kmsWalked: Double
    @NSManaged public var stepCount: Int16

}

extension StepEntry : Identifiable {

}
