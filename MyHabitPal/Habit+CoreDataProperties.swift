//
//  Habit+CoreDataProperties.swift
//  MyHabitPal
//
//  Created by Artem on 14/12/2022.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var actualDate: String?
    @NSManaged public var colorAlpha: Float
    @NSManaged public var colorBlue: Float
    @NSManaged public var colorGreen: Float
    @NSManaged public var colorRed: Float
    @NSManaged public var completionProgress: Double
    @NSManaged public var completionHoursProgress: Double
    @NSManaged public var completionMinutesProgress: Double
    @NSManaged public var completionSecondsProgress: Double
    @NSManaged public var disabledButton: Bool
    @NSManaged public var habitIcon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var loggedDays: Int32
    @NSManaged public var loggedHours: Int32
    @NSManaged public var loggedMinutes: Int32
    @NSManaged public var loggedSeconds: Int32
    @NSManaged public var logMinutes: Bool
    @NSManaged public var name: String?
    @NSManaged public var notificationDay: Int32
    @NSManaged public var notificationHour: Int32
    @NSManaged public var totalLoggedTime: Int32
    @NSManaged public var notificationMinute: Int32
    @NSManaged public var target: Int32
    @NSManaged public var targetDays: Float
    @NSManaged public var logged: NSSet?
    
    public var wrappedActualDate: String {
        actualDate ?? "1 December 2022"
    }
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    public var wrappedName: String {
        name ?? "default name"
    }
    public var wrappedHabitIcon: String {
        habitIcon ?? "star"
    }
    
    public var loggedArray: [Logged] {
        let set = logged as? Set<Logged> ?? []
        
        func sortLoggedByName(_ logged1: Logged, _ logged2: Logged) -> Bool {
          return logged1.wrappedName < logged2.wrappedName
        }

        return set.sorted(by: sortLoggedByName)

        }
    }



// MARK: Generated accessors for logged
extension Habit {

    @objc(addLoggedObject:)
    @NSManaged public func addToLogged(_ value: Logged)

    @objc(removeLoggedObject:)
    @NSManaged public func removeFromLogged(_ value: Logged)

    @objc(addLogged:)
    @NSManaged public func addToLogged(_ values: NSSet)

    @objc(removeLogged:)
    @NSManaged public func removeFromLogged(_ values: NSSet)

}

extension Habit : Identifiable {

}
