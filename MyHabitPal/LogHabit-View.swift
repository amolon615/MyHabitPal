//
//  HabitDetailedView-View.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI
import Foundation
import CoreData

struct HabitDetailedView_View: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    //timer variables
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var timer: Timer?
    
    
    @State private var startDisabled = false
    @State private var pauseDisabled = true
    @State private var resumeDisabled = true
    
    
    
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
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: CGFloat(1.0 - habit.colorRed), green: CGFloat(1.0 - habit.colorGreen), blue: CGFloat(1.0 - habit.colorRed)), location: 0.3),
                .init(color: Color(red: CGFloat(habit.colorRed + 0.2), green: CGFloat(habit.colorGreen + 0.2), blue: CGFloat(habit.colorBlue + 0.2)), location: 0.3),
            ], center: .center, startRadius: 100, endRadius: 400)
            .ignoresSafeArea()
            
 
                        VStack{
                     
                            Image(systemName: habit.habitIcon ?? "star")
                                .foregroundColor(Color(red: CGFloat(habit.colorRed), green: CGFloat(habit.colorGreen), blue: CGFloat(habit.colorRed)))
                                .font(.system(size: 70))
                                .padding()
                            Text(habit.name ?? "unknown habit")

                                HStack{
                                    Text("Days logged")
                                    Text("\(habit.loggedDays)")
                                        
                                }
                                if habit.logMinutes == true {
                                    Text("\(minutes) minutes & \(seconds) seconds logged today.")
                                }
                            
                        
                            VStack {
                                   Button("Log an activity today") {
                                       withAnimation(){
                                           
                                           habit.loggedDays += 1
                                           habit.name = habit.name
                                           //create new variable to store yesterdays date
                                           habit.actualDate = logDate
                                           
                                           disableButton = true
                                           try? moc.save()
                                       }
                                }
                                   .frame(width: 200, height: 60)
                                   .foregroundColor(.white)
                                   .background(disableButton ? .gray: .blue)
                                   .cornerRadius(10)
                                   .disabled(disableButton)
                                  
                                
                                //if user added timer tracking
                                if habit.logMinutes {
                                    VStack {
                                        Text("\(minutes):\(seconds)")
                                            .font(.largeTitle)
                                        HStack{
                                            Button {
                                                startTimer()
                                                startDisabled = true  //disabling start button
                                                pauseDisabled = false   //enabling pause button
                                                resumeDisabled = true  //disabling resume button
                                                
                                            } label: {  Text("Start")
                                            }
                                            .disabled(startDisabled)
                                            .frame(width: 70, height: 70)
                                            .foregroundColor(.white)
                                            .background(startDisabled ? .gray: .blue)
                                            .cornerRadius(10)
                                            
                                            Button {
                                                stopTimer()
                                                
                                                startDisabled = true
                                                pauseDisabled = true
                                                resumeDisabled = false
                                                
                                                habit.loggedMinutes = Int32(minutes)
                                                habit.loggedSeconds = Int32(seconds)
                                                
                                                try? moc.save()
                                                
                                                print("time was successfully saved")
                                            } label : {
                                                Text("Pause")
                                            }
                                            .disabled(pauseDisabled)
                                            .frame(width: 70, height: 70)
                                            .foregroundColor(.white)
                                            .background(pauseDisabled ? .gray: .blue)
                                            .cornerRadius(10)
                                            
                                            Button {
                                                resumeTimer()
                                                
                                                startDisabled = true
                                                pauseDisabled = false
                                                resumeDisabled = true
                                                
                                            }label:{   Text("Resume")
                                            }
                                            .frame(width: 70, height: 70)
                                            .foregroundColor(.white)
                                            .background(resumeDisabled ? .gray: .blue)
                                            .cornerRadius(10)
                                            .disabled(resumeDisabled)
                                           
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.vertical, 20)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .ignoresSafeArea()
                        .onAppear {
                    minutes = Int(habit.loggedMinutes)
                    seconds = Int(habit.loggedSeconds)
                    
    //disabling button after logging day
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




