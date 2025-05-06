//
//  UserstepEntry+CoreDataProperties.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 04/30/25
//
//

import Foundation
import CoreData


extension UserStepEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserStepEntry> {
        return NSFetchRequest<UserStepEntry>(entityName: "UserStepEntry")
    }

    @NSManaged public var calories: Double
    @NSManaged public var date: Date?
    @NSManaged public var kmsWalked: Double
    @NSManaged public var stepCount: Int16
    @NSManaged public var goalCount: Int16
    @NSManaged public var unit: Int16

}

extension UserStepEntry : Identifiable {

}
