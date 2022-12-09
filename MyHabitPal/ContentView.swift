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
            VStack{
              
                List{
                    ForEach(habits, id:\.name){ habit in
                                VStack{
                                    HStack{
                                        Spacer()
                                        Image(systemName: habit.habitIcon ?? "star")
                                            .foregroundColor(Color(red: CGFloat(habit.colorRed), green: CGFloat(habit.colorGreen), blue: CGFloat(habit.colorBlue)))
                                            .font(.system(size: 40))
                                        
                                        Text(habit.name ?? "Unknown")
                                        Spacer()
                                    }
                                    CompletionView_View(habit: habit)
                                }

                        .sheet(isPresented: $showLogHabit) {
                            HabitDetailedView_View(habit: habit)
                        }
                        .sheet(isPresented: $addHabit) {
                            AddHabitView()
                        }
                        .sheet(isPresented: $showSettings) {
                            Settings_View()
                        }
                        .onTapGesture {
                            showLogHabit = true
                        }
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: deleteHabits)
                }
//                .background {
//                    Rectangle()
//                        .animatableGradient(fromGradient: gradient1, toGradient: gradient2, progress: progress)
//                        .ignoresSafeArea()
//                        .onAppear {
//                            withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
//                                self.progress = 1.0
//                            }
//                        }
//                }
                .scrollContentBackground(.hidden)
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
            
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        showSettings = true
//                    } label: {
//                        Image(systemName: "gear")
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        addHabit = true
//                    } label: {
//                        Image(systemName: "plus.circle")
//                    }
//                }
//            }
            
            Spacer()
                    .background(Color.clear)
        }//ZStack
    }//body
    
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
