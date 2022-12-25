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
    
    
    @State private var startDisabled = false
    @State private var pauseDisabled = true
    @State private var resumeDisabled = true
    
    @State private var gradIn = false
    @State private var gradOut = false
    
    
//    @State private var confetti: Int = 0
    
    @State private var completionProgress = 0.0
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
            ScrollView{
                VStack{
                    ZStack {
                        // 2
                        ZStack {
                            Circle()
                                .stroke(
                                    Color.gray.opacity(0.5),
                                    lineWidth: 30
                                )
                            Circle()
                                .trim(from: 0, to: completionProgress)
                                .stroke(
                                    (Color(red: CGFloat(habit.colorRed), green: CGFloat(habit.colorGreen), blue: CGFloat(habit.colorRed))),
                                    style: StrokeStyle(
                                        lineWidth: 30,
                                        lineCap: .round
                                    )
                                )
                                .rotationEffect(.degrees(-90))
                                .animation(.easeOut, value: completionProgress)
                            // 1
                            
                        }
                        // 3
                        .frame(width: 100, height: 100)
                    }
                    .padding()
                    
                    
                    VStack{
                        
                        
                        //                    HStack{
                        //                        Text("Target days:")
                        //                        Text(String(format: "%g", habit.targetDays))
                        //
                        //                    }
                        //
                        //                    HStack{
                        //                        Text("Days logged:")
                        //                        Text("\(habit.loggedDays)")
                        //                    }
                        
                        
                        
                        
                        
                        
                    }

                    
                    
                    VStack {
                        HStack{
                            Text("\(minutes):\(seconds)")
                                .font(.largeTitle)
                        }
                        Button{
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
                            Text(habit.disabledButton ? "Come back tomorrow" : "Log day")
                        }
                        .frame(width: 180, height: 50)
                        .foregroundColor(.white)
                        .disabled(habit.disabledButton)
                        .background(habit.disabledButton ? .gray: .blue)
                        .cornerRadius(10)
                        
                        
                        
                        
                        //if user added timer tracking
                        if habit.logMinutes {
                            VStack {
                                HStack{
                                    Button {
                                        startTimer()
                                        startDisabled = true  //disabling start button
                                        pauseDisabled = false   //enabling pause button
                                        resumeDisabled = true  //disabling resume button
                                        
                                    } label: {
                                        Image(systemName: "play")
                                    }
                                    .disabled(startDisabled)
                                    .frame(width: 50, height: 50)
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
                                        
                                        print("\(habit.loggedMinutes) was saved")
                                        print("today's date is \(habit.actualDate!)")
                                    } label : {
                                        Image(systemName: "pause.circle")
                                    }
                                    .disabled(pauseDisabled)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                    .background(pauseDisabled ? .gray: .blue)
                                    .cornerRadius(10)
                                    
                                    Button {
                                        resumeTimer()
                                        
                                        startDisabled = true
                                        pauseDisabled = false
                                        resumeDisabled = true
                                        
                                    }label:{
                                        Image(systemName: "playpause")
                                    }
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                    .background(resumeDisabled ? .gray: .blue)
                                    .cornerRadius(10)
                                    .disabled(resumeDisabled)
                                 
                                    
                                    
                                }
                                Chart(habit.loggedArray.sorted {$0.date! < $1.date!} ){
                                    AreaMark(
                                        x: .value("Date", $0.date!),
                                        y: .value("Minutes", $0.minutes)
                                    )
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
                                .frame(height: 250 )
                                .cornerRadius(10)
                            
                                
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
                newLogged.minutes = habit.loggedMinutes + habit.loggedSeconds / 60
                newLogged.id = UUID()
                habit.actualDate = Date.now.formatted(date: .numeric, time: .omitted)


                habit.addToLogged(newLogged)
                habit.totalLoggedTime = habit.loggedMinutes
                print("total logged time \(habit.totalLoggedTime)")
                habit.loggedMinutes = 0
                minutes = 0
                seconds = 0
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




