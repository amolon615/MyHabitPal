//
//  ContentView.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI
import CoreData
import Charts



struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var habits: FetchedResults<Habit>
 
    @State private var addHabit = false
    @State private var showSettings = false
    @State private var showLogHabit = false
    
    @State private var scale: CGFloat = 1
    
    
    func animatableGradient(fromGradient: Gradient, toGradient: Gradient, progress: CGFloat) -> some View {
        self.modifier(AnimatableGradientModifier(fromGradient: fromGradient, toGradient: toGradient, progress: progress))
    }
    
    @State private var progress: CGFloat = 0
       let gradient1 = Gradient(colors: [.purple, .yellow])
       let gradient2 = Gradient(colors: [.blue, .purple])

    @State private var offset: CGFloat = 0
    
    @State private var isPresentingHabit: Habit? = nil
    
    var body: some View {
        ZStack{
            NavigationView{
                    ZStack {
//                        Rectangle()
//                            .animatableGradient(fromGradient: gradient1, toGradient: gradient2, progress: progress)
//                            .ignoresSafeArea()
//                            .onAppear {
//                                withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
//                                    self.progress = 2.0
//                                }
//                            }
                        if habits.count == 0 {
                            VStack{
                                Image("bot_main")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110)
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
                                            .frame(width: 180, height: 50)
                                            .background(colorScheme == .dark ? .gray : .white)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .opacity(0.7)
                                            .shadow(radius: 10)
                                        HStack{
                                            Text("Create new habit!")
                                            Image(systemName: "hand.tap.fill")
                                        }
                                            .opacity(0.5)
                                            .foregroundColor(colorScheme == .dark ? .black : .black)
                                            .onTapGesture {
                                                addHabit.toggle()
                                            }
                                    }
                                    .padding()
                            }
                        } else {
                        VStack{
                            List{
                                ForEach(habits, id:\.name){ habit in
                                    VStack{
                                        HStack{
                                            NavigationLink(destination: {
                                                HabitDetailedView_View(habit: habit)
                                            }, label: {
                                                HStack{
                                                    Image(systemName: habit.habitIcon ?? "star")
                                                        .foregroundColor(Color(red: CGFloat(habit.colorRed), green: CGFloat(habit.colorGreen), blue: CGFloat(habit.colorBlue)))
                                                        .font(.system(size: 20))
                                                        .padding(.leading)
                                                    Text(habit.name ?? "Unknown")
                                                    Spacer()
                                                    ProgressView(habit: habit)
                                                        .frame(width: 40, height: 30)
                                                  
                                                        .padding()
                                                }
                                                
                                            })
                                            
                                        }
                                    }
                                    .listRowSeparator(.hidden)
                                }
                                
                                .onDelete(perform: deleteHabits)
                                
                            }
                            .shadow(radius: 10)
                            
                            .scrollContentBackground(.hidden)
                            
                            
                        }
                        .opacity(0.7)
                    }
                    }
                    .toolbar {
                        ToolbarItem{
                            Button{
                                addHabit = true
                                HapticManager.instance.impact(style: .light)
                            } label: {
                                Label("Add new habit", systemImage: "plus")
                                    .foregroundColor(habits.isEmpty ? (colorScheme == .dark ? .black : .white) : (colorScheme == .dark ? .white : .black))
                            }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button{
                                showSettings = true
                                HapticManager.instance.impact(style: .light)
                            } label: {
                                Label("Add new habit", systemImage: "gear")
                                    .foregroundColor(habits.isEmpty ? (colorScheme == .dark ? .black : .white) : (colorScheme == .dark ? .white : .black))
                            }
                            
                        }
                    }
                    .navigationTitle(habits.isEmpty ? "" : "Habits")
                }

            .sheet(isPresented: $addHabit) {
                    AddHabitView()
                }
                .sheet(isPresented: $showSettings) {
                    Settings_View()
                }
             
            
        }
    }
    
    func deleteHabits(at offsets: IndexSet) {
        for offset in offsets {
            let habit = habits[offset]
            moc.delete(habit)
            HapticManager.instance.impact(style: .light)
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
