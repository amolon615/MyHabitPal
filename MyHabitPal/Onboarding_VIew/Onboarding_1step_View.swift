//
//  Onboarding_1step_View.swift
//  MyHabitPal
//
//  Created by Artem on 21/12/2022.
//

import SwiftUI
import Combine

struct Onboarding_1step_View: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var appState: AppState
    
    
    @State var userName = ""
    let userNameLimit = 15
    
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        VStack{
            Image("bot_main")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .padding()
                .shadow(color: .gray, radius: 10, x: 0, y: 5)
                .offset(x: 0, y: offset)
                .onAppear() {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)){
                            self.offset = self.offset == 0 ? 5 : 0
                        }
                    }
                }
            
            ZStack{
                Rectangle()
                    .frame(width: 170, height: 50)
                    .background(colorScheme == .dark ? .white : .black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
                TextField("Enter your name", text: $userName)
                    .autocorrectionDisabled()
                    .onReceive(Just(userName)) { _ in limitText(userNameLimit) }
                    .frame(width: 130, height: 50)
                    .padding()
                    .foregroundColor(colorScheme == .dark ? .white : .gray)
                
            }
            
            Button {
                HapticManager.instance.impact(style: .light)
                
                saveData(key: "username", value: userName)
                
                appState.hasOnboarded = true
                saveOnboardingStatus(key: "onboarded", value: true)
                
            } label: {
                Label("Save", systemImage: "square.and.arrow.down")
                
            }
            .disabled(userName == "" ? true : false)
            .frame(width: 170, height: 50)
            .background(.white)
            .cornerRadius(10)
        }
      
    }
    
    //limit name field by symbols
    func limitText(_ upper: Int) {
        if userName.count > upper {
            userName = String(userName.prefix(upper))
        }
    }
    
    func saveData(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func saveOnboardingStatus(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func loadBool(key: String) -> Bool? {
        return UserDefaults.standard.bool(forKey: key)
    }
}

struct Onboarding_1step_View_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding_1step_View()
    }
}
