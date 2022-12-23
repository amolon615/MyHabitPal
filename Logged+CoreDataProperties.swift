//
//  Logged+CoreDataProperties.swift
//  MyHabitPal
//
//  Created by Artem on 14/12/2022.
//
//

import Foundation
import CoreData


extension Logged {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Logged> {
        return NSFetchRequest<Logged>(entityName: "Logged")
    }


    @NSManaged public var name: String?
    @NSManaged public var hours: Int32
    @NSManaged public var minutes: Int32
    @NSManaged public var cdminutes: Int32
    @NSManaged public var date: String?
    @NSManaged public var habit: Habit?
    
    public var wrappedName: String {
        name ?? "unknown"
    }

    public var wrappedDate: String {
        date ?? "unknown"
    }
}

extension Logged : Identifiable {

}
