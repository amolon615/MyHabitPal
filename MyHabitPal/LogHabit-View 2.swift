//
//  HabitDetailedView-View.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI
import Foundation
import CoreData
import ConfettiSwiftUI

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
    
    @State private var gradIn = false
    @State private var gradOut = false
    
    
    @State private var confetti: Int = 0
    
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var habits: FetchedResults<Habit>
    
    @State var habit: Habit

    @State var disableMessage = ""
    
    
    
    var logDate =  Date.now.formatted(date: .long, time: .omitted)
     
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: CGFloat(gradIn ? (1.0 - habit.colorRed) : (habit.colorRed)), green: CGFloat(gradIn ? (1.0 - habit.colorGreen): habit.colorGreen), blue: CGFloat(gradIn ? (1.0 - habit.colorBlue): habit.colorBlue)), location: 0.3),
                .init(color: Color(red: CGFloat(gradOut ? (habit.colorRed + 0.2) : habit.colorRed), green: CGFloat(gradOut ? (habit.colorGreen + 0.2) : habit.colorGreen), blue: CGFloat(gradOut ? (habit.colorBlue + 0.2) : habit.colorBlue)), location: 0.3),
            ], center: .center, startRadius: 250, endRadius: 400)
            .onAppear {
                withAnimation(Animation.linear(duration: 5.0).repeatForever()) {
                    gradIn.toggle()
                    gradOut.toggle()
                }
            }
            .ignoresSafeArea()
            
 
                        VStack{
                     
//                            ZStack {
//                                // 2
//                                ZStack {
//                                    Circle()
//                                        .stroke(
//                                            Color.gray.opacity(0.5),
//                                            lineWidth: 30
//                                        )
//                                    Circle()
//                                        .trim(from: 0, to: habit.completionProgress)
//                                        .stroke(
//                                           (Color(red: CGFloat(habit.colorRed), green: CGFloat(habit.colorGreen), blue: CGFloat(habit.colorRed))),
//                                            style: StrokeStyle(
//                                                lineWidth: 30,
//                                                lineCap: .round
//                                            )
//                                        )
//                                        .rotationEffect(.degrees(-90))
//                                        // 1
//                                        .animation(.easeOut, value: habit.completionProgress)
//                                    Text("\(habit.loggedDays)")
//                                }
//                                // 3
//                                .frame(width: 200, height: 200)
//                            }
//                            .padding()
                            

                                HStack{
                                    Text(habit.name ?? "unknown habit")
                                    Text("Target days:")
                                    Text(String(format: "%g", habit.targetDays))
                                    Text("Days logged")
                                    Text("\(habit.loggedDays)")
                                        
                                }
                                if habit.logMinutes == true {
                                    VStack{
                                        Text("\(minutes) minutes logged.")
                                        Text("\(seconds) seconds logged.")
                                    }
                                }
                            
                        
                            VStack {
                                   Button("Log an activity today") {
                                       withAnimation(){
                                           
                                           habit.loggedDays += 1
                                           habit.completionProgress = (1 / (Double(habit.targetDays)) * Double(habit.loggedDays))
                                           
                                           try? moc.save()
                                           print("\(habit.loggedDays) logged days saved")
                                           print("\(habit.completionProgress) progress value set")
                                           confetti += 1
                                       }
                                       if habit.actualDate! == Date.now.formatted(date: .long, time: .omitted) {
  
                                           habit.disabledButton = true
                                           
                                           try? moc.save()
                                           
//                                           disableMessage = "You've already logged your habit today! Come back tomorrow!"
//                                           print("Log button was disabled")
//                                           print("Today's date is \(logDate)")
//                                           print("Yesterday's date was \(habit.actualDate!)")

                                       }
                                }
                                   .frame(width: 200, height: 60)
                                   .foregroundColor(.white)
                                   .disabled(habit.disabledButton)
                                   .background(habit.disabledButton ? .gray: .blue)
                                   .cornerRadius(10)
                                 
                                   
                                  
                                
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
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .ignoresSafeArea()
                        .onAppear {
                    minutes = Int(habit.loggedMinutes)
                    seconds = Int(habit.loggedSeconds)
                    
    //disabling button after logging day
                            
                 
                }
               
        }
        
        .confettiCannon(counter: $confetti)
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




