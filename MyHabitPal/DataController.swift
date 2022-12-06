//
//  DataController.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Habit")
    
    init() {
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
        }    
    }
}
