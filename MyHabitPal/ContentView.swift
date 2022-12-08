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
    @State private var showSettings = false
    
    var body: some View {
        ZStack{
            VStack{
                NavigationView{
                    List{
                        ForEach(habits, id:\.name){ habit in
                            NavigationLink {
                                HabitDetailedView_View(habit: habit)
                            } label: {
                                VStack{
                                    HStack{
                                        Image(systemName: habit.habitIcon ?? "star")
                                        Text(habit.name ?? "Unknown")
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
                            EditButton()
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showSettings = true
                            } label: {
                                Image(systemName: "gear")
                            }
                        }
                        
                    }
                    
                    
                }
                Spacer()
                HStack{
                    Spacer()
                    Button("Add habit"){
                        addHabit = true
                    }
                    .frame(width: 300, height: 45)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(10)
                    Spacer()
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
