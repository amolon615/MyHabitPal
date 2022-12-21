//
//  Step4_end.swift
//  MyHabitPal
//
//  Created by Artem on 20/12/2022.
//

import SwiftUI

struct Step4_end: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    func animatableGradient(fromGradient: Gradient, toGradient: Gradient, progress: CGFloat) -> some View {
        self.modifier(AnimatableGradientModifier(fromGradient: fromGradient, toGradient: toGradient, progress: progress))
    }
    
    @State private var progress: CGFloat = 0
       let gradient1 = Gradient(colors: [.purple, .yellow])
       let gradient2 = Gradient(colors: [.blue, .purple])
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack{
            Rectangle()
                .animatableGradient(fromGradient: gradient1, toGradient: gradient2, progress: progress)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
                        self.progress = 1.0
                    }
                }
            
            Rectangle()
                .fill(.white)
                .frame(width: 350, height: 350)
                .cornerRadius(10)
                .opacity(0.8)
                .shadow(radius: 10)
            
            Image("bot_settings")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .padding()
                .offset(x: 0, y: offset)
                .onAppear() {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)){
                    self.offset = self.offset == 0 ? 5 : 0
                }
            }
                
        }
            
        }
    }
}

struct Step4_end_Previews: PreviewProvider {
    static var previews: some View {
        Step4_end()
    }
}