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
        NavigationView{
            List{
                ForEach(habits, id:\.name){ habit in
                    NavigationLink {
                        HabitDetailedView_View(habit: habit)
                    } label: {
                        VStack{
                            HStack{
                                Image(systemName: habit.habitIcon ?? "star")
                                    .foregroundColor(Color(red: CGFloat(habit.colorRed), green: CGFloat(habit.colorGreen), blue: CGFloat(habit.colorBlue)))
                                
                                Text(habit.name ?? "Unknown")
                                Spacer()
                            }
                            CompletionView_View(habit: habit)
                        }
                    }
                    
                }
                .onDelete(perform: deleteHabits)
            }
            .navigationTitle("myHabitPal")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addHabit = true
                    } label: {
                        Image(systemName: "plus.circle")
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
