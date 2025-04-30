//
//  UserstepEntry+CoreDataProperties.swift
//  StepsTrackerApp
//
//  Created by Rajesh Kumar Reddy Avula on 4/29/25.
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

}

extension UserStepEntry : Identifiable {

}
