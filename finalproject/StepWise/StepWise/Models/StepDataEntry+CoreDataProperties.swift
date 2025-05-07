//
//  StepDataEntry+CoreDataProperties.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
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
