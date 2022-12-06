//
//  HabitDetailedView-View.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI

struct HabitDetailedView_View: View {
    
    @Environment(\.managedObjectContext) var moc
    
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var habits: FetchedResults<Habit>
    
    @State var habit: Habit
    
    @Environment(\.dismiss) var dismiss
    
    @State var disableButton = true
    @State var disableMessage = ""
    
    @State var habitTracked = true
    
    
    var logDate: String {
        let date = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
      
    
 
    
    
    
    var body: some View {
        NavigationView{
            VStack{
                    Text(habit.name ?? "unknown habit")
                    Text("\(habit.loggedDays)")
                Button("Log an activity today") {
   
                    habit.loggedDays += 1
                    habit.name = habit.name
                    habit.actualDate = logDate
                    disableButton = true
                    
                    if habit.strike != 0 && habitTracked {
                        habit.strike += 1
                        print("Today's strike is \(habit.strike)")
                    } else {
                        print("strike was destroyed")
                    }
  
                    try? moc.save()
//                    dismiss()
                    //disable button if today was completed
                }
                .disabled(disableButton)
            }
            .onAppear {
                if logDate == habit.actualDate! {
                    disableButton = true
                    print("Log button was disabled")
                    print("Today's date is \(logDate)")
                    print("Yesterday's date was \(habit.actualDate!)")

                } else {
                    disableButton = false
                    print("Log button was enabled")
                    print("Today's date is \(logDate)")
                    print("Yesterday's date was \(habit.actualDate!)")
                }
            }
                
            }
            .navigationTitle(habit.name ?? "unknown")
        }
    }



