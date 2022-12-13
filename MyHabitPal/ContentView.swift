//
//  ContentView.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI
import CoreData



struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var habits: FetchedResults<Habit>
 
    @State private var addHabit = false
    @State private var showSettings = false
    @State private var showLogHabit = false
    
    
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
                        Rectangle()
                            .animatableGradient(fromGradient: gradient1, toGradient: gradient2, progress: progress)
                            .ignoresSafeArea()
                            .onAppear {
                                withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
                                    self.progress = 2.0
                                }
                            }
                        if habits.count == 0 {
                            VStack{
                                Image("bot_main")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130)
                                    .padding()
                                    .offset(x: 0, y: offset)
                                    .animation(.interpolatingSpring(stiffness: 100, damping: 10))
                                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                                    .onAppear() {
                                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                                            self.offset = self.offset == 0 ? 5 : 0
                                        }
                                    }
                        
                                    ZStack{
                                        Rectangle()
                                            .frame(width: 330, height: 50)
                                            .background(.white)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .opacity(0.5)
                                        Text("To start tracking your habits create one!")
                                            .opacity(0.5)
                                            .foregroundColor(.black)
                                            .onTapGesture {
                                                addHabit.toggle()
                                            }
                                    }
                                     
                                

                              
                                    
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
                                                        .font(.system(size: 40))
                                                        .padding(.leading)
                                                    Text(habit.name ?? "Unknown")
                                                    Spacer()
                                                    ProgressView(habit: habit)
                                                        .frame(width: 70, height: 70)
                                                        .padding()
                                                }
                                                
                                            })
                                            
                                        }
                                    }
                                    
                                    
                                    .listRowSeparator(.hidden)
                                }
                                
                                
                                
                                .onDelete(perform: deleteHabits)
                                
                            }
                            
                            .scrollContentBackground(.hidden)
                            
                            
                        }
                        .opacity(0.7)
                    }//if
                    }
                }

           
            VStack{
                Spacer()
                HStack{
                    withAnimation(.easeInOut(duration: 2)) {
                        Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            
                    }
                    .padding()
                    .frame(width:50, height: 50)
                    .background(.blue)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .shadow(radius: 10)
                    .opacity(0.8)
                    .padding(.leading)
                    }
                    Spacer()
                    withAnimation(.easeInOut(duration: 2)) {
                        Button {
                        addHabit = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(width:50, height: 50)
                    .background(.blue)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .shadow(radius: 10)
                    .opacity(0.8)
                    .padding(.trailing)
                    }
                }
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
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
