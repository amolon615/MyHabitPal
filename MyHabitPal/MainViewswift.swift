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

    @State var step = false
 


    var body: some View {
        
        if let finishedOnboarding = loadBool(key: "finishedOnboarding"){
            if finishedOnboarding{
                ContentView()
                    .environmentObject(appState)
            } else {
                OnboardingView()
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


