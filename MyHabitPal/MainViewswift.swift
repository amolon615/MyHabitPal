//
//  MainViewswift.swift
//  MyHabitPal
//
//  Created by Artem on 25/12/2022.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var hasOnboarded: Bool

    init(hasOnboarded: Bool) {
        self.hasOnboarded = hasOnboarded
    }
}


struct MainView: View {
    @StateObject var appState = AppState(hasOnboarded: false)
    
    
    var body: some View {
        
        if let loadedOnBoardingStatus = loadBool(key: "onboarded") {
            
            if loadedOnBoardingStatus {
            ContentView()
                .environmentObject(appState)
        } else {
            Onboarding_1step_View()
                .environmentObject(appState)
        }
        }
           
       
    }
    func loadBool(key: String) -> Bool? {
        return UserDefaults.standard.bool(forKey: key)
    }
}

struct MainViewswift_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
