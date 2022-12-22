//
//  HabitDetailedView-View.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI
import CoreData
import ConfettiSwiftUI
import Charts





struct HabitDetailedView_View: View {
    
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    
   

    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var habits: FetchedResults<Habit>
    
    //passing selected habit to navigation view
    @State var habit: Habit
    
    //timer variables
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var timer: Timer?
    @State private var pauseState = true
    
    let minutesSegments = [15, 30, 45, 60]
    
    @State var selectedMinutes = 0
    
    
    @State  var completionProgress = 0.0
    @State  var completionMinutesProgress = 0.0
    @State  var completionHoursProgress = 0.0
    @State  var completionSecondsProgress = 0.0
    
    
    
    @State private var disableButton = false
    @State private var disabledSegmentButton = false
    
    @State var loggedDays: Int

    @State var animatedSegment = false
    @State var animatedLog = false
  

    
    @State var  confetti = 0
    
    @State private var showingSuccess = false
    
    var logDate =  Date.now.formatted(date: .numeric, time: .omitted)
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            GradientView()

            ScrollView {
                            VStack{
                                HStack{
                                    VStack{
                                        VStack(alignment: .leading){
                                            HStack{
                                                Text("Days:")
                                                Text("\(habit.loggedDays) / \(String(format: "%g", habit.targetDays))")
                                            }
                                            
                                            HStack{
                                                Text("Hours: ")
                                                Text("\(hours)")
                                            }
                                           
                                            HStack{
                                                Text("Minutes: ")
                                                Text("\(minutes)")
                                            }
                       
                                        }
                                    }
                                    VStack {
                                        ZStack{ //progress circles
                                            ProgressView(width: 20, circleProgress: habit.completionProgress, color: .red, frameWidth: 150.0, frameHeight: 150.0)
                                                .padding()
                                          
                                            ProgressView(width: 20, circleProgress: completionHoursProgress, color: .blue, frameWidth: 100.0, frameHeight: 100.0)
                                                .padding()
//
                                            ProgressView(width: 20, circleProgress: completionMinutesProgress, color: .green, frameWidth: 50.0, frameHeight: 50.0)
                                                .padding()
//

//
                                        }
                                    }
                                }
                                HStack{
                                    withAnimation { Button{ //days logging
                                        animatedLog = true
                                            loggedDays = Int(habit.loggedDays)
                                            loggedDays += 1
                                            completionProgress = CGFloat((1 / (Double(habit.targetDays)) * Double(loggedDays)))
                                            habit.loggedDays = Int32(loggedDays)
                                            habit.completionProgress = completionProgress
                                            
                                            try? moc.save()
                                            print("\(habit.loggedDays) logged days saved")
                                            print("\(habit.completionProgress) progress value set")
                                            
                                            confetti += 1
                                            HapticManager.instance.notification(type: .success)
                                        
                                        if habit.actualDate! == Date.now.formatted(date: .numeric, time: .omitted) {
                                            
                                            habit.disabledButton = true
                                            
                                            try? moc.save()
                                            
                                            print("Log button was disabled")
                                            print("Today's date is \(logDate)")
                                            print("Yesterday's date was \(habit.actualDate!)")
                                        }
                                        
                                        if loggedDays == Int(habit.targetDays) {
                                            showingSuccess.toggle()
                                        }
                                        
                                    } label: {
                                        HStack{
                                            Image(systemName: habit.disabledButton ? "xmark.circle" : "checkmark.circle")
                                            Text(habit.disabledButton ? "Logged" : "Log day")
                                        }
                                    }
                                    .scaleEffect(animatedLog ? 0.6 : 1)
                                    .onChange(of: animatedLog) { newValue in
                                        withAnimation(.easeInOut(duration: 0.7)) {
                                            animatedLog = false
                                        }
                                    }
                                    }
                                    .frame(width: 150, height: 50)
                                    .foregroundColor(.white)
                                    .disabled(habit.disabledButton)
                                    .background(habit.disabledButton ? .gray.opacity(0.7): .blue)
                                    .cornerRadius(10)
                                    
                                }
                               
                        }
                        .frame(width: 350, height: 330)
                        .background(.thinMaterial)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        
                VStack{
                    Text("Select to select amount of minutes")
                        .padding()
                    HStack{
                        Picker("Select amount of minutes", selection: $selectedMinutes) {
                            ForEach(minutesSegments, id:\.self) {
                                Text("\($0)")
                            }
                        }
                        .padding()

                    }
                    .pickerStyle(.segmented)
                    
                    .onAppear { //getting data from CD to draw changes
                        minutes = Int(habit.loggedMinutes)
                        hours = Int(habit.loggedHours)
                        
                        completionHoursProgress = habit.completionHoursProgress
                        completionMinutesProgress = habit.completionMinutesProgress
                        
                    }
                    
                    HStack{
                        Button {
                            minutes += selectedMinutes
                            
                            if minutes >= 60 {
                                hours += 1
                                minutes = minutes - 60
                            }
                            
                            if hours >= 24 {
                                //add condition to handle number more than 24 hours
                                habit.disableSegmentButton = true
                                hours = 24
                                minutes = 0
                                
                                try? moc.save()
                                
                            }
                            
                            habit.loggedMinutes = Int32(minutes)
                            print("\(habit.loggedMinutes) minutes was saved")
                            habit.loggedHours = Int32(hours)
                            completionMinutesProgress = (1 / (Double(60)) * Double(minutes))
                            completionHoursProgress = (1 / (Double(12)) * Double(hours))
                            try? moc.save()
                            
                            animatedSegment = true
                            HapticManager.instance.notification(type: .success)
                            
                        }label:{
                            Label("Add segment", systemImage: "square.and.arrow.down")
                        }
                        .frame(width: 150, height: 50)
                        .disabled(habit.disableSegmentButton)
                        .background(habit.disableSegmentButton ? Color.gray : Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding()
                        .scaleEffect(animatedSegment ? 0.8 : 1)
                        .opacity(animatedSegment ? 0.7 : 1)
                        .onChange(of: animatedSegment) { newValue in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                animatedSegment = false
                            }
                        }
                    }
                }
                .frame(width: 350, height: 210)
                .background(.thinMaterial)
                .cornerRadius(10)
                .shadow(radius: 5)
                
                
                
                    VStack { //drawing charts
                        
                        if habit.loggedArray.count < 3 {
                            ZStack{
                                Rectangle()
                                    .fill(.white.opacity(0.5))
                                    .frame(width: 300, height: 250)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                VStack{
                                    Image("avatar")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70)
                                        .clipShape(Circle())
                                        .padding()
                                    ZStack{
                                        VStack{
                                            Text("Get back here in a few days.")
                                                .font(.caption)
                                            Text("I'll draw nice chart for you!")
                                                .font(.caption)
                                        }
                                    }
                                    .frame(width: 250, height: 90)
                                    .background(.white.opacity(0.5))
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                }
                            }
                        } else {
                            
                            Chart(habit.loggedArray.sorted {$0.date! < $1.date!} ){
                                BarMark(
                                    x: .value("Date", $0.date!),
                                    y: .value("Minutes", $0.minutes)
                                )
                                .foregroundStyle(Color(red: CGFloat(habit.colorRed), green: CGFloat(habit.colorGreen), blue: CGFloat(habit.colorRed)).gradient)
                                .interpolationMethod(.catmullRom)
                            }
                            
                            .frame(height: 250)
                            
                            
                            List{
                                ForEach(habit.loggedArray.sorted {$0.date! > $1.date! }){logged in
                                    HStack{
                                        Text(logged.date ?? "default date")
                                        Text("\(logged.minutes) minutes logged")
                                    }
                                }
                            }
                            
                            .scrollContentBackground(.hidden)
                            .frame(width: 350, height: habit.loggedArray.isEmpty ? 0 : 250)
                            .opacity(0.7)
                            .cornerRadius(10)
                        }
                        }
                    .padding()
                    .frame(maxWidth: 350)
                    .padding(.vertical, 20)
                    .background(.thinMaterial)
                    .cornerRadius(10)
                }
            .sheet(isPresented: $showingSuccess) {
                VStack{
                    Text("Congratulations!")
                        .onAppear {
                            confetti += 1
                        }
                }
                .confettiCannon(counter: $confetti)
            }
        }.onAppear{
            if habit.actualDate != Date.now.formatted(date: .numeric, time: .omitted) {

                print("Today's \(habit.actualDate!)")
                print("User saved \(habit.loggedMinutes)")
                let newLogged = Logged(context: moc)
                newLogged.date = habit.actualDate
                newLogged.minutes = habit.loggedMinutes + habit.loggedHours * 60
                newLogged.id = UUID()
                habit.actualDate = Date.now.formatted(date: .numeric, time: .omitted)


                habit.addToLogged(newLogged)

                
                habit.totalLoggedTime = habit.loggedMinutes + (habit.loggedHours * 60)
                print("total logged minutes \(habit.totalLoggedTime)")
                habit.loggedMinutes = 0
                minutes = 0
                hours = 0
            
                habit.disabledButton = false
                habit.disableSegmentButton = false
                try? moc.save()
               
                dismiss()
                print("Today's \(habit.actualDate ?? "default")")
                print("User saved: \(habit.loggedMinutes)")

                print("Yesterday was \(newLogged.date!). User saved \(newLogged.minutes)")
            }
        }
        .confettiCannon(counter: $confetti)
        }
   
}




