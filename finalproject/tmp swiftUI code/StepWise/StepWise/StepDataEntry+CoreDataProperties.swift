//
//  StepDataEntry+CoreDataProperties.swift
//  StepWise
//
//  Created by Sudeepthi Rebbalapalli on 5/5/25.
//
//

import Foundation
import CoreData


extension StepDataEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepDataEntry> {
        return NSFetchRequest<StepDataEntry>(entityName: "StepDataEntry")
    }

    @NSManaged public var stepCount: Int16
    @NSManaged public var date: Date?
    @NSManaged public var kmsWalked: Double
    @NSManaged public var caloriesBurnt: Double

}

extension StepDataEntry : Identifiable {

}
