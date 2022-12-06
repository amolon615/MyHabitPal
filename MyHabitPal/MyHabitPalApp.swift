//
//  MyHabitPalApp.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI

@main
struct MyHabitPalApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
