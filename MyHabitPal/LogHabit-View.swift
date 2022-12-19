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
    
    //timer variables
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var timer: Timer?
    
    
    @State private var pauseState = true
    
    
    @State private var startDisabled = false
    @State private var pauseDisabled = true
    @State private var resumeDisabled = true
    
    @State private var gradIn = false
    @State private var gradOut = false
    

    
    @State  var completionProgress = 0.0
    @State  var completionMinutesProgress = 0.0
    @State  var completionHoursProgress = 0.0
    @State  var completionSecondsProgress = 0.0
    
    
    
    @State private var disableButton = false
    @State private var loggedDays = 0

    
    //passing selected habit to navigation view
    @State var habit: Habit

    
    @State var  confetti = 0
    
    @State private var showingSuccess = false
    
    var logDate =  Date.now.formatted(date: .numeric, time: .omitted)
     
    
    func animatableGradient(fromGradient: Gradient, toGradient: Gradient, progress: CGFloat) -> some View {
        self.modifier(AnimatableGradientModifier(fromGradient: fromGradient, toGradient: toGradient, progress: progress))
    }
    
    @State private var progress: CGFloat = 0
       let gradient1 = Gradient(colors: [.purple, .yellow])
       let gradient2 = Gradient(colors: [.blue, .purple])
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .animatableGradient(fromGradient: gradient1, toGradient: gradient2, progress: progress)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
                        self.progress = 2.0
                        completionProgress = habit.completionProgress
                    }
                }
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
                                          
                                           
                                            HStack{
                                                Text("Seconds: ")
                                                Text("\(seconds)")
                                            }
                                        }
                                    }
                                    VStack {
                                        ZStack{
                                            ZStack {
                                                // 2
                                                ZStack {
                                                    Circle()
                                                        .stroke(
                                                            Color.red.opacity(0.5),
                                                            lineWidth: 15
                                                        )
                                                    Circle()
                                                        .trim(from: 0, to: completionProgress)
                                                        .stroke(
                                                            Color.red,
                                                            style: StrokeStyle(
                                                                lineWidth: 15,
                                                                lineCap: .round
                                                            )
                                                        )
                                                        .rotationEffect(.degrees(-90))
                                                        .animation(.easeOut, value: completionProgress)
                                                    // 1
                                                    
                                                }
                                                // 3
                                                .frame(width: 150, height: 150)
                                            }
                                            .padding()//days circle
                                            ZStack {
                                                // 2
                                                ZStack {
                                                    Circle()
                                                        .stroke(
                                                            Color.blue.opacity(0.5),
                                                            lineWidth: 15
                                                        )
                                                    Circle()
                                                        .trim(from: 0, to: completionSecondsProgress)
                                                        .stroke(
                                                            (Color.blue),
                                                            style: StrokeStyle(
                                                                lineWidth: 15,
                                                                lineCap: .round
                                                            )
                                                        )
                                                        .rotationEffect(.degrees(-90))
                                                        .animation(.easeOut, value: completionSecondsProgress)
                                                    // 1
                                                    
                                                }
                                                // 3
                                                .frame(width: 115, height: 115)
                                            }
                                            .padding()//seconds circle
                                            ZStack {
                                                // 2
                                                ZStack {
                                                    Circle()
                                                        .stroke(
                                                            Color.green.opacity(0.5),
                                                            lineWidth: 15
                                                        )
                                                    Circle()
                                                        .trim(from: 0, to: completionMinutesProgress)
                                                        .stroke(
                                                            (Color.green),
                                                            style: StrokeStyle(
                                                                lineWidth: 15,
                                                                lineCap: .round
                                                            )
                                                        )
                                                        .rotationEffect(.degrees(-90))
                                                        .animation(.easeOut, value: completionMinutesProgress)
                                                    // 1
                                                    
                                                }
                                                // 3
                                                .frame(width: 80, height: 80)
                                            }
                                            .padding()//minutes circle
                                            
                                            ZStack {
                                                // 2
                                                ZStack {
                                                    Circle()
                                                        .stroke(
                                                            Color.yellow.opacity(0.5),
                                                            lineWidth: 15
                                                        )
                                                    Circle()
                                                        .trim(from: 0, to: completionHoursProgress)
                                                        .stroke(
                                                            (Color.yellow),
                                                            style: StrokeStyle(
                                                                lineWidth: 15,
                                                                lineCap: .round
                                                            )
                                                        )
                                                        .rotationEffect(.degrees(-90))
                                                        .animation(.easeOut, value: completionHoursProgress)
                                                    // 1
                                                    
                                                }
                                                // 3
                                                .frame(width: 45, height: 45)
                                            }
                                            .padding()//hours circle
                                        }
                                    }
                                }
                                HStack{
                                    Button{ //days logging
                                        withAnimation(){
                                            loggedDays = Int(habit.loggedDays)
                                            loggedDays += 1
                                            habit.loggedDays = Int32(loggedDays)
                                            completionProgress = (1 / (Double(habit.targetDays)) * Double(habit.loggedDays))
                                            
                                            habit.completionProgress = completionProgress
                                            try? moc.save()
                                            print("\(habit.loggedDays) logged days saved")
                                            print("\(habit.completionProgress) progress value set")
                                            confetti += 1
                                            HapticManager.instance.notification(type: .success)
                                        }
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
                                            Image(systemName: habit.disabledButton ? "checkmark.circle" : "xmark.circle")
                                            Text(habit.disabledButton ? "Logged" : "Log day")
                                        }
                                    }
                                    .frame(width: 120, height: 50)
                                    .foregroundColor(.white)
                                    .disabled(habit.disabledButton)
                                    .background(habit.disabledButton ? .gray.opacity(0.7): .blue)
                                    .cornerRadius(10)
                                    
                                    Button { //timer controls
                                        if pauseState == true {
                                            startTimer()
                                            pauseState = false
                                        } else {
                                            stopTimer()
                                            pauseState = true
                                            habit.loggedMinutes = Int32(minutes)
                                            habit.loggedSeconds = Int32(seconds)
                                            habit.loggedHours = Int32(hours)
                                            
                                            habit.completionSecondsProgress = completionSecondsProgress
                                            habit.completionMinutesProgress = completionMinutesProgress
                                            habit.completionHoursProgress = completionHoursProgress
                                            
                                            try? moc.save()
                                            
                                            print("\(habit.loggedMinutes) was saved")
                                            print("today's date is \(habit.actualDate!)")
                                        }
                                        
                                    } label: {
                                        HStack{
                                            Image(systemName: pauseState ? "play" : "pause.circle")
                                            Text(pauseState ? "Start timer" : "Pause timer")
                                        }
                                    }
                                    .disabled(startDisabled)
                                    .frame(width: 120, height: 50)
                                    .foregroundColor(.white)
                                    .background(.blue.opacity(0.7))
                                    .cornerRadius(10)
                                }
                               
                        }
                        .frame(width: 350, height: 350)
                        .background(.thinMaterial)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .onAppear { //getting data from CD to draw changes
                            minutes = Int(habit.loggedMinutes)
                            seconds = Int(habit.loggedSeconds)
                            hours = Int(habit.loggedHours)
                            
                            completionHoursProgress = habit.completionHoursProgress
                            completionMinutesProgress = habit.completionMinutesProgress
                            completionSecondsProgress = habit.completionSecondsProgress
                            
                        }
                
                if habit.loggedArray.count > 0 {
                    VStack { //drawing charts
                        if habit.loggedArray.count > 4 {
                            Chart(habit.loggedArray.sorted {$0.date! < $1.date!} ){
                                AreaMark(
                                    x: .value("Date", $0.date!),
                                    y: .value("Minutes", $0.minutes)
                                )
                                .foregroundStyle(Color(red: CGFloat(habit.colorRed), green: CGFloat(habit.colorGreen), blue: CGFloat(habit.colorRed)).gradient)
                                .interpolationMethod(.catmullRom)
                            }
                            
                            .frame(height: habit.loggedArray.isEmpty ? 0 : 250)
                        }
                                 
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
                    .padding()
                    .frame(maxWidth: 350, maxHeight: habit.logMinutes ? .infinity : 0)
                    .padding(.vertical, 20)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .ignoresSafeArea()
                }
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
                newLogged.minutes = habit.loggedMinutes + habit.loggedHours / 60
                newLogged.id = UUID()
                habit.actualDate = Date.now.formatted(date: .numeric, time: .omitted)


                habit.addToLogged(newLogged)
                habit.totalLoggedTime = habit.loggedMinutes
                print("total logged time \(habit.totalLoggedTime)")
                habit.loggedMinutes = 0
                minutes = 0
                seconds = 0
                hours = 0
            
                habit.disabledButton = false
                try? moc.save()
               
                dismiss()
                print("Today's \(habit.actualDate ?? "default")")
                print("User saved: \(habit.loggedMinutes)")

                print("Yesterday was \(newLogged.date!). User saved \(newLogged.minutes)")
            }
        }
        .confettiCannon(counter: $confetti)
        }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.seconds += 1
            completionSecondsProgress = (1 / (Double(60)) * Double(seconds))
            
            if self.seconds == 60 {
                self.minutes += 1
                completionMinutesProgress = (1 / (Double(60)) * Double(minutes))
                self.seconds = 0
                
                if self.minutes == 60 {
                    self.hours += 1
                    completionHoursProgress = (1 / (Double(12)) * Double(hours))
                    self.minutes = 0
                }
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




