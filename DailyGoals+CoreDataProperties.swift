//
//  DailyGoals+CoreDataProperties.swift
//  WaterIntake
//
//  Created by Tanmay N. Gandhi on 06/12/24.
//
//

import Foundation
import CoreData


extension DailyGoals {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyGoals> {
        return NSFetchRequest<DailyGoals>(entityName: "DailyGoals")
    }

    @NSManaged public var username: String?
    @NSManaged public var date: String?
    @NSManaged public var waterIntake: String?
    @NSManaged public var containerType: String?

}

extension DailyGoals : Identifiable {

}
