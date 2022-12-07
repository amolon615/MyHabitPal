//
//  ContentView.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var habits: FetchedResults<Habit>
    
    
    
    @State private var addHabit = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(habits, id:\.name){ habit in
                    NavigationLink {
                        HabitDetailedView_View(habit: habit)
                    } label: {
                        HStack{
                            Image(systemName: habit.habitIcon ?? "star")
                            Text(habit.name ?? "Unknown")
                        }
                    }

                }
                .onDelete(perform: deleteHabits)
            }
            .navigationTitle("myHabitPal")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
            }
        }
        
        .sheet(isPresented: $addHabit) {
            AddHabitView()
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
