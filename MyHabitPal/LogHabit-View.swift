//
//  HabitDetailedView-View.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI
import Foundation

struct HabitDetailedView_View: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    //timer variables
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var timer: Timer?
    
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var habits: FetchedResults<Habit>
    
    //passing selected habit to navigation view
    @State var habit: Habit

    @State var disableButton = true
    @State var disableMessage = ""
    
    
    
    var logDate: String {
        let date = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
      
    
 
    
    
    
    var body: some View {
        NavigationView{
            VStack {
                    Text(habit.name ?? "unknown habit")
                    Text("\(habit.loggedDays)")
                    Text("\(minutes) \(seconds) logged today")
                    Text(disableMessage)
                Button("Log an activity today") {
   
                    habit.loggedDays += 1
                    habit.name = habit.name
                    habit.actualDate = logDate
                    
                    disableButton = true
                    
                    
//                    if habit.currentStreak == 0 {
//                        habit.currentStreak += 1
//                        habit.maxStreak = habit.currentStreak
//                        print("Today's streak is \(habit.currentStreak)")
//                    } else {
//                        habit.currentStreak = 0
//                        print("streak was destroyed")
//                        print("Max streak was \(habit.maxStreak)")
//                    }
  
                    try? moc.save()
//                    dismiss()
                    //disable button if today was completed
                }
                .disabled(disableButton)
                if habit.logMinutes {
                    VStack {
                        Text("\(minutes):\(seconds)")
                            .font(.largeTitle)
                        
                        Button(action: startTimer) {
                            Text("Start")
                        }
                        
                        Button {
                            stopTimer()
                            habit.loggedMinutes = Int32(minutes)
                            habit.loggedSeconds = Int32(seconds)
                            habit.loggedHours = Int32(hours)
                            print("time was successfully saved")
                            try? moc.save()
                        } label : {
                            Text("Stop")
                        }
                        
                        Button(action: resumeTimer) {
                            Text("Resume")
                        }
                    }
                }
                
            }
            .onAppear {
                minutes = Int(habit.loggedMinutes)
                seconds = Int(habit.loggedSeconds)
                
                
                if logDate == habit.actualDate! {
                    disableButton = true
                    disableMessage = "You've already logged your habit today! Come back tomorrow!"
                    print("Log button was disabled")
                    print("Today's date is \(logDate)")
                    print("Yesterday's date was \(habit.actualDate!)")

                } else {
                    disableButton = false
                    disableMessage = ""
                    print("Log button was enabled")
                    print("Today's date is \(logDate)")
                    print("Yesterday's date was \(habit.actualDate!)")
                }
            }
           
            }
            
            .navigationTitle(habit.name ?? "unknown")
        }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.seconds += 1
            
            if self.seconds == 60 {
                self.minutes += 1
                self.seconds = 0
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resumeTimer() {
        startTimer()
    }
    }




