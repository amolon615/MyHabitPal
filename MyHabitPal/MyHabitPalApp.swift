//
//  MyHabitPalApp.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI


class AppState: ObservableObject {
    @Published var hasOnboarded1step: Bool
    @Published var hasOnboarded2step: Bool
    @Published var hasOnboarded3step: Bool

    init(hasOnboarded1step: Bool, hasOnboarded2step: Bool, hasOnboarded3step: Bool) {
        self.hasOnboarded1step = hasOnboarded1step
        self.hasOnboarded2step = hasOnboarded2step
        self.hasOnboarded3step = hasOnboarded3step
    }
}


@main
struct MyHabitPalApp: App {
    @StateObject private var dataController = DataController()
    @StateObject var appState = AppState(hasOnboarded1step: false, hasOnboarded2step: false, hasOnboarded3step: false)
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some Scene {
        WindowGroup {
            if appState.hasOnboarded1step == false {
                Onboarding_1step_View()
                    .environmentObject(appState)
            } else if appState.hasOnboarded2step == false{
                OnboardingAddView()
                    .environmentObject(appState)
            } else if appState.hasOnboarded3step == false {
                Step3_end()
                    .environmentObject(appState)
            } else {
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
            }
        }
    }
}



//
//@main
//struct MyHabitPalApp: App {
//    @StateObject private var dataController = DataController()
//    @StateObject var appState = AppState(hasOnboarded1step: false, hasOnboarded2step: false, hasOnboarded3step: false)
//
//    @Environment(\.colorScheme) var colorScheme
//
//    var body: some Scene {
//        WindowGroup {
//            if appState.hasOnboarded3step {
//                //
//            }
//          ContentView()
//                .environment(\.managedObjectContext, dataController.container.viewContext)
//        }
//    }
//}
