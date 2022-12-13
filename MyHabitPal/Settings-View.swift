//
//  Settings-View.swift
//  MyHabitPal
//
//  Created by Artem on 08/12/2022.
//

import SwiftUI
import SafariServices
import CoreData

struct Settings_View: View {
    @State private var chooseTheme = false
    @State private var showPrivacy: Bool = false
    @State private var showTOS: Bool = false
    
    @Environment(\.managedObjectContext) var moc
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
                VStack(spacing: 30){//main vstack
                    //section 1
                    VStack(spacing: 10) {
                        
                        ZStack(alignment: .leading) {
                            withAnimation(.easeInOut(duration: 2)) {
                                Button{
                                //
                                }label:{
                                    HStack{
                                        Image(systemName: "paintpalette")
                                            .padding(.leading)
                                            .foregroundColor(.black)
                                        Text("Choose theme")
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                                
                            }   .padding()
                                .frame(width: 350,height: 40)
                                .background(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                           
                        }
                        ZStack(alignment: .leading) {
                            withAnimation(.easeInOut(duration: 2)) {
                                Button{
                                //
                                }label:{
                                    HStack{
                                        Image(systemName: "arrow.clockwise")
                                            .padding(.leading)
                                        Text("Set-up gradients")
                                        Spacer()
                                    }.foregroundColor(.black)
                                }
                                
                            }   .padding()
                                .frame(width: 350,height: 40)
                                .background(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                           
                        }
                        
                      
                    }
                    VStack{
                        ZStack(alignment: .leading) {
                            withAnimation(.easeInOut(duration: 2)) {
                                Button{
                                    showTOS.toggle()
                                }label:{
                                    HStack{
                                        Image(systemName: "newspaper")
                                            .padding(.leading)
                                        Text("Privacy Policy")
                                        Spacer()
                                    }.foregroundColor(.black)
                                }
                                
                            }   .padding()
                                .frame(width: 350,height: 40)
                                .background(.white)
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
                                        Text("Terms of Use")
                                        Spacer()
                                    }.foregroundColor(.black)
                                }
                                
                            }   .padding()
                                .frame(width: 350,height: 40)
                                .background(.white)
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
                                            .padding(.leading)
                                        Text("Leave Feadback")
                                        Spacer()
                                    }.foregroundColor(.black)
                                }
                                
                            }   .padding()
                                .frame(width: 350,height: 40)
                                .background(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                           
                        }
                        ZStack(alignment: .leading) {
                            withAnimation(.easeInOut(duration: 2)) {
                                Button{
                                //
                                }label:{
                                    HStack{
                                        Image(systemName: "star")
                                            .padding(.leading)
                                        Text("Rate Habitify")
                                        Spacer()
                                    }.foregroundColor(.black)
                                }
                                
                            }   .padding()
                                .frame(width: 350,height: 40)
                                .background(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                           
                        }
                        Spacer()
                       
                            
                    }
                }
                VStack{
                    Text("Version 1.0")
                        .foregroundColor(.secondary)
                    Text("myHabitPal (c)")
                        .foregroundColor(.secondary)
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
