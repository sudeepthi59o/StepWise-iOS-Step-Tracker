//
//  UserstepEntry+CoreDataProperties.swift
//  StepsTrackerApp
//
//  Created by Rajesh Kumar Reddy Avula on 4/29/25.
//
//

import Foundation
import CoreData


extension UserstepEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserstepEntry> {
        return NSFetchRequest<UserstepEntry>(entityName: "UserstepEntry")
    }

    @NSManaged public var calories: Double
    @NSManaged public var date: Date?
    @NSManaged public var kmsWalked: Double
    @NSManaged public var stepCount: Int16

}

extension UserstepEntry : Identifiable {

}
