//
//  Animation.swift
//  MyHabitPal
//
//  Created by Artem on 07/12/2022.
//

import SwiftUI

struct Animation: View {
    @State private var showPulsating = false
       
       let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
       
       var body: some View {
           ZStack {
               LinearGradient(gradient: Gradient(colors: [.blue, .red]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
               
               if showPulsating {
                   PulsateMultipleView().blur(radius: 2)
               }
               
           }.onReceive(timer) { time in
               self.showPulsating.toggle()
           }
       }
}

struct PulsateMultipleView: View {
    
    var body: some View {
        ZStack {
            PulsateView(delay: Double(0.1))
            PulsateView(delay: Double(0.4))
        }
    }
}
struct PulsateView: View {
    
    @State private var show = false
    var delay: Double
    
    var body: some View {
           
        Circle()
            .frame(width: 1, height: 1)
            .foregroundColor(Color.white)
            .opacity(show ? 0 : 0.2)
            .scaleEffect(show ? 1000 : 1)
            .animation(.easeInOut(duration: 1))
       
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                self.show = true
            }
        }
    }
}


struct Animation_Previews: PreviewProvider {
    static var previews: some View {
        Animation()
    }
}
