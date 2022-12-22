//
//  Settings-View.swift
//  MyHabitPal
//
//  Created by Artem on 08/12/2022.
//

import SwiftUI
import SafariServices
import CoreData
import StoreKit

struct Settings_View: View {
    @State private var chooseTheme = false
    @State private var showPrivacy: Bool = false
    @State private var showTOS: Bool = false
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.requestReview) var requestReview
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var habits: FetchedResults<Habit>
    
    @State private var showGradientSettings = false
    
    func animatableGradient(fromGradient: Gradient, toGradient: Gradient, progress: CGFloat) -> some View {
        self.modifier(AnimatableGradientModifier(fromGradient: fromGradient, toGradient: toGradient, progress: progress))
    }
    
    @State private var progress: CGFloat = 0
       let gradient1 = Gradient(colors: [.purple, .yellow])
       let gradient2 = Gradient(colors: [.blue, .purple])
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack{
            GradientView()
            
                .sheet(isPresented: $showPrivacy){
                SFSafariViewWrapper(url: URL(string:"https://apple.com")!)
                }
                
                .sheet(isPresented: $showTOS){
                SFSafariViewWrapper(url: URL(string:"https://apple.com")!)
                }
            
                .sheet(isPresented: $showGradientSettings) {
                    //
                }
            
            
            VStack(spacing: 20){
                Spacer()
                Text("Settings")
                    .font(.title)
                    .foregroundColor(.white)
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
                VStack(spacing: 30){//main vstack
                   
                    VStack{
                        ZStack(alignment: .leading) {
                            withAnimation(.easeInOut(duration: 2)) {
                                Button{
                                    showTOS.toggle()
                                }label:{
                                    HStack{
                                        Image(systemName: "newspaper")
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                            .padding(.leading)
                                        Text("Privacy Policy")
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                        Spacer()
                                    }.foregroundColor(.black)
                                }
                                
                            }   .padding()
                                .frame(width: 350,height: 40)
                                .background(colorScheme == .dark ? .gray.opacity(0.7) : .white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                           
                        }
                        ZStack(alignment: .leading) {
                            withAnimation(.easeInOut(duration: 2)) {
                                Button{
                                showTOS = true
                                }label:{
                                    HStack{
                                        Image(systemName: "ruler")
                                            .padding(.leading)
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                        Text("Terms of Use")
                                        Spacer()
                                    }
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                }
                                
                            }   .padding()
                                .frame(width: 350,height: 40)
                                .background(colorScheme == .dark ? .gray.opacity(0.7) : .white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                           
                        }
                    }
                    
                    
                    VStack{
                        ZStack(alignment: .leading) {
                            withAnimation(.easeInOut(duration: 2)) {
                                Button{
                                //
                                }label:{
                                    HStack{
                                        Image(systemName: "questionmark.bubble")
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                            .padding(.leading)
                                        Text("Leave Feadback")
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                        Spacer()
                                    }.foregroundColor(.black)
                                }
                                
                            }   .padding()
                                .frame(width: 350,height: 40)
                                .background(colorScheme == .dark ? .gray.opacity(0.7) : .white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                           
                        }
                        ZStack(alignment: .leading) {
                            withAnimation(.easeInOut(duration: 2)) {
                                Button{
                                requestReview()
                                }label:{
                                    HStack{
                                        Image(systemName: "star")
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                            .padding(.leading)
                                        Text("Rate Habitify")
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                        Spacer()
                                    }.foregroundColor(.black)
                                }
                                
                            }   .padding()
                                .frame(width: 350,height: 40)
                                .background(colorScheme == .dark ? .gray.opacity(0.5) : .white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                           
                        }
                        Spacer()
                       
                            
                    }
                }
                VStack{
                    Text("Version 1.0")
                        .foregroundColor(.white)
                    Text("myHabitPal (c)")
                        .foregroundColor(.white)
                }
                    .font(.caption)
            }
        }
    }
    
    struct SFSafariViewWrapper: UIViewControllerRepresentable {
        let url: URL

        func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
            return SFSafariViewController(url: url)
        }

        func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
            return
        }
    }
        
}


struct Settings_View_Previews: PreviewProvider {
    static var previews: some View {
        Settings_View()
    }
}
