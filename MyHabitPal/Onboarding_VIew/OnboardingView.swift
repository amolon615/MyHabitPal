//
//  OnboardingView.swift
//  MyHabitPal
//
//  Created by Artem on 22/12/2022.
//

import SwiftUI
import Combine
import SFSymbolsPicker
import CoreData
import ConfettiSwiftUI


struct OnboardingView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var habits: FetchedResults<Habit>
    
    
    @State private var currentTab = 0
    
    @State var isAnimated = false
    
    @State var animated = false
    
    @State private var name = ""
    let textLimit = 15
    
    var addDisabled: Bool {
        if name == "" {
            return true
        } else {
            return false
        }
    }
    
    @State var userName = ""
    let userNameLimit = 15
    
    @State private var offset: CGFloat = 0
    
    @State private var habitIcon = "star"
    @State private var iconPicker = false
    
    @State private var showColorPicker = false
    
    @State private var showOnboarding = 0
    @State private var isShowingOnboardingFinish = false
    
    @State private var myColor = Color(.sRGB, red:0.4, green: 0.3, blue: 0.4)
    
    @State var cgcolorRed: CGFloat = 0.0
    @State var cgcolorGreen: CGFloat  = 0.0
    @State var cgcolorBlue: CGFloat = 0.0
    @State var cgcolorAlpha: CGFloat = 0.0
    
    

    @State private var targetDays = 14.0
    
    @State private var loggedDays = 0
    
    @State var  confetti = 0
    
    //timer block
    @State private var logMinutes = false
    @State private var loggedHours = 0
    @State private var loggedMinutes = 0
    @State private var loggedSeconds = 0
    
    @State private var completionProgress: Double = 0
    @State private var completionMinutesProgress: Double = 0.0
    @State private var completionHoursProgress: Double = 0.0
    @State private var completionSecondsProgress: Double = 0.0

    @State private var selectedHour = 1
    @State private var selectedMinute = 1
    @State private var selectedDay = 1
    @State private var remind = false
    
    
    var actualDate = Date.now.formatted(date: .numeric, time: .omitted)
    
    
    func animatableGradient(fromGradient: Gradient, toGradient: Gradient, progress: CGFloat) -> some View {
        self.modifier(AnimatableGradientModifier(fromGradient: fromGradient, toGradient: toGradient, progress: progress))
    }
    
    @State private var progress: CGFloat = 0
       let gradient1 = Gradient(colors: [.purple, .yellow])
       let gradient2 = Gradient(colors: [.blue, .purple])
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $currentTab,
                       content:  {
                    ZStack{
                        ZStack{
                            GradientView()
                            VStack{
                                Image("bot_main")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .padding()
                                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                                    .offset(x: 0, y: offset)
                                    .onAppear() {
                                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                                            withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)){
                                                self.offset = self.offset == 0 ? 5 : 0
                                            }
                                        }
                                    }
                                
                                ZStack{
                                    Rectangle()
                                        .frame(width: 170, height: 50)
                                        .background(colorScheme == .dark ? .white : .black)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    
                                    TextField("Enter your name", text: $userName)
                                        .autocorrectionDisabled()
                                        .onReceive(Just(userName)) { _ in limitText(userNameLimit) }
                                        .frame(width: 130, height: 50)
                                        .padding()
                                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                                    
                                }
                                
                //                Button {
                //                    HapticManager.instance.impact(style: .light)
                //
                //                    saveData(key: "username", value: userName)
                //
                                    
                //
                //                } label: {
                //                    Label("Save", systemImage: "square.and.arrow.down")
                //
                //                }
                //                .disabled(userName == "" ? true : false)
                //                .frame(width: 170, height: 50)
                //                .background(.white)
                //                .cornerRadius(10)
                            }
                        }
                        VStack{
                            Spacer()
                            Button {
                                withAnimation {
                                    currentTab = 1
                                    isAnimated.toggle()
                                    
                                }
                                HapticManager.instance.impact(style: .light)
                                
                                saveData(key: "username", value: userName)
                                print("\(userName) name saved")
                            }label:{
                                Label("Save", systemImage: "square.and.arrow.down")
                            }
                            
                            .frame(width: 150, height: 50)
                            .background(.white)
                            .cornerRadius(10)
                            .padding()
                            .scaleEffect(isAnimated ? 0.4 : 1)
                            .onChange(of: isAnimated) { newValue in
                                withAnimation{
                                    isAnimated = false
                                }
                            }
                            
                        }
                    }
                               .tag(0)
            
            
           ZStack {
                GradientView()
    //
                VStack (spacing: 0) {//column
                    Image("bot_add")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .padding()
                        .offset(x: 0, y: offset)
                        .onAppear() {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)){
                            self.offset = self.offset == 0 ? 5 : 0
                        }
                    }
                }
                        .onTapGesture {
                            showColorPicker = true
                        }
                    VStack (spacing: 0){ //first section
                      
                        ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 10)
                                .fill(colorScheme == .dark ? .gray : .white)
                                .frame(width: 350, height: 50)
                                .shadow(radius: 10)
                                .padding()
                                .opacity(0.7)
                            VStack{
                                TextField("Enter your habit's name", text: $name)
                                    .onReceive(Just(name)) { _ in limitText(textLimit) }
                                    .padding()
                                    .padding(.leading)
                                    .foregroundColor(.black)
                                    .frame(width: 350, height: 40)
                                    .disableAutocorrection(true)
                            }
                            
                        }
                        ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 10)
                                .fill(colorScheme == .dark ? .gray : .white)
                                .frame(width: 350, height: remind ? 350 : 190)
                                .shadow(radius: 10)
                                .padding()
                                .opacity(0.7)
                            VStack{
                                HStack{
                                    Text(String(format: "%g", targetDays))
                                    Text("days selected")
                                    
                                }
                                Slider(value: $targetDays, in: 1...60, step: 1)
                                    .frame(width: 320)
                                    .padding()
                                    .padding(.leading)
                                Toggle("Log time?", isOn: $logMinutes)
                                    .padding()
                                    .frame(width: 320)
                            }
                        }
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(colorScheme == .dark ? .gray : .white)
                                .frame(width: 350, height: 130)
                                .shadow(radius: 10)
                                .padding()
                                .opacity(0.7)
                            
                            VStack (spacing: 0){
                                    HStack{
                                        Text("Choose icon")
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                        Spacer()
                                        Image(systemName: "\(habitIcon)")
                                            .padding(.leading)
                                            .foregroundColor(myColor)
                                        }
                                .frame(width: 310, height: 20)
                                .padding()
                                .padding(.leading)
                                .onTapGesture(perform: {
                                        iconPicker.toggle()
                                    })
                                HStack{
                                    Text("Choose color")
                                        .padding(.leading)
                                        .padding()
                                    Spacer()
                                    Circle()
                                        .fill(myColor)
                                        .frame(width: 20)
                                        .padding()
                                        .onTapGesture {
                                            showColorPicker.toggle()
                                            
                                        }
                                        
                                    
                                        
                                }
                                .padding()
                            }
                        }
                    }
                    
                    .sheet(isPresented: $iconPicker) {
                        SFSymbolsPicker(isPresented: $iconPicker, icon: $habitIcon, category: .habit, axis: .vertical, haptic: true)
                            .presentationDetents([.medium, .fraction(0.6)])
                            .padding()
                            .onChange(of: habitIcon) { newValue in
                                iconPicker = false
                            }
                            
                        
                    }
                    .sheet(isPresented: $showColorPicker) {
                        VStack (spacing: 0){
                            HStack{
                                Rectangle()
                                      .fill(Color.red)
                                      .frame(width:50)
                                      .clipShape(Circle())
                                      .onTapGesture {
                                          myColor = Color(.sRGB, red:1, green: 0, blue: 0)
                                          showColorPicker = false
                                      }
                                          
                                Rectangle()
                                     .fill(Color(.sRGB, red:0, green: 0, blue: 1))
                                      .frame(width: 50)
                                      .background(Color(.sRGB, red:0, green: 0, blue: 1))
                                      .clipShape(Circle())
                                      .onTapGesture {
                                          myColor = Color(.sRGB, red:0, green: 0, blue: 1)
                                          showColorPicker = false
                                      }
                                Rectangle()
                                       .fill(Color(.sRGB, red:0, green: 1, blue: 0))
                                       .frame(width: 50)
                                       .clipShape(Circle())
                                       .onTapGesture {
                                           myColor = Color(.sRGB, red:0, green: 1, blue: 0)
                                           showColorPicker = false
                                       }
                                
                             
                                Rectangle()
                                      .fill(Color(.sRGB, red:0, green: 1, blue: 0))
                                      .frame(width: 50)
                                      .clipShape(Circle())
                                      .onTapGesture {
                                          myColor = Color(.sRGB, red:0, green: 1, blue: 0)
                                          showColorPicker = false
                                      }
                                Rectangle()
                                     .fill(Color(.sRGB, red:0, green: 1, blue: 1))
                                      .frame(width: 50)
                                      .clipShape(Circle())
                                      .onTapGesture {
                                          myColor = Color(.sRGB, red:0, green: 1, blue: 1)
                                          showColorPicker = false
                                      }
                            }
                            .padding()
                            HStack{
                                Rectangle()
                                      .fill(Color(.sRGB, red:255, green: 0, blue: 128))
                                      .frame(width:50)
                                      .clipShape(Circle())
                                      .onTapGesture {
                                          myColor = Color(.sRGB, red:255, green: 0, blue: 128)
                                          showColorPicker = false
                                      }
                                          
                                Rectangle()
                                     .fill(Color(.sRGB, red:255, green: 128, blue: 0))
                                      .frame(width: 50)
                                      .clipShape(Circle())
                                      .onTapGesture {
                                          myColor = Color(.sRGB, red:255, green: 128, blue: 0)
                                          showColorPicker = false
                                      }
                                Rectangle()
                                       .fill(Color(.sRGB, red:0, green: 1, blue: 0))
                                       .frame(width: 50)
                                       .clipShape(Circle())
                                       .onTapGesture {
                                           myColor = Color(.sRGB, red:0, green: 1, blue: 0)
                                           showColorPicker = false
                                       }
                                
                             
                                Rectangle()
                                    .fill(Color(.sRGB, red: 1, green: 0.2, blue: 0))
                                      .frame(width: 50)
                                      .clipShape(Circle())
                                      .onTapGesture {
                                          myColor = Color(.sRGB, red:0, green: 1, blue: 0)
                                          showColorPicker = false
                                      }
                                Rectangle()
                                     .fill(Color(.sRGB, red:0, green: 1, blue: 1))
                                      .frame(width: 50)
                                      .clipShape(Circle())
                                      .onTapGesture {
                                          myColor = Color(.sRGB, red:0, green: 1, blue: 1)
                                          showColorPicker = false
                                      }
                            }
                            .padding()
                        }
                        .presentationDetents([.medium, .fraction(0.3)])
                    }
                }
                VStack{
                    Spacer()
                    HStack{
                        withAnimation(.easeInOut(duration: 2)) {
                            Button {
                                add()
                                HapticManager.instance.notification(type: .success)
                                withAnimation {
                                    currentTab = 2

                                }
                                animated = true
                                
                                //
                        } label: {
                            HStack{
                                Text("Add habit")
                                    .foregroundColor(.blue)
                                Image(systemName: "hand.tap")
                                    .foregroundColor(.blue)
                            }
                        }
                            
                        .frame(width:150, height: 50)
                        .background(.white)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .opacity(0.8)
                        .padding()
                        .scaleEffect(isAnimated ? 0.4 : 1)
                        .onChange(of: isAnimated) { newValue in
                            withAnimation{
                                isAnimated = false
                            }
                        }
                        }
                    }
                }
            }
                               .tag(1)
            
            
            
            ZStack{
                Rectangle()
                    .animatableGradient(fromGradient: gradient1, toGradient: gradient2, progress: progress)
                    .ignoresSafeArea()
                    .onAppear {
                        withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
                            self.progress = 1.0
                        }
                    }
                
                Rectangle()
                    .fill(.white)
                    .frame(width: 350, height: 350)
                    .cornerRadius(10)
                    .opacity(0.8)
                    .shadow(radius: 10)
                
                VStack{
                    Image("bot_settings")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .padding()
                        .offset(x: 0, y: offset)
                        .onAppear() {
                            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                                withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)){
                                    self.offset = self.offset == 0 ? 5 : 0
                                }
                            }
                        }
                    Text("Congratulations!")
                        .font(.title)
                    Text("Now you can add all your habits!")
                    Button {
                        appState.hasOnboarded = true
                        HapticManager.instance.impact(style: .light)
                        saveOnboardingStatus(key: "finishedOnboarding", value: true)
                        confetti += 1
                        
                    } label: {
                        Label("Finish", systemImage: "checkmark.circle")
                    }
                    
                    .frame(width: 150, height: 50)
                    .background(.white.opacity(0.7))
                    .cornerRadius(10)
                    .foregroundColor(.blue)
                    .padding()
                    .scaleEffect(isAnimated ? 0.4 : 1)
                    .onChange(of: isAnimated) { newValue in
                        withAnimation{
                            isAnimated = false
                        }
                    }
                   
                    
                }
                
                
            }
                               .tag(2)
                       })
//                   .tabViewStyle(PageTabViewStyle())
        .tabViewStyle(.page(indexDisplayMode: .never))
                   .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                   .edgesIgnoringSafeArea(.all)
    }
    
    
    
    func saveData(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    func saveOnboardingStatus(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func limitText(_ upper: Int) {
        if userName.count > upper {
            userName = String(userName.prefix(upper))
        }
    }
    
    func add(){
        let newHabit = Habit(context: moc)
        
        let pickedColor = UIColor(myColor)
        
        newHabit.id = UUID()
        newHabit.name = name
        newHabit.loggedDays = Int32(loggedDays)
        newHabit.actualDate = actualDate
        newHabit.habitIcon = habitIcon
        newHabit.logMinutes = logMinutes
        newHabit.loggedHours = Int32(loggedHours)
        newHabit.loggedMinutes = Int32(loggedMinutes)
        newHabit.loggedSeconds = Int32(loggedSeconds)
        newHabit.targetDays = Float(targetDays)
        newHabit.completionProgress = completionProgress
        newHabit.disabledButton = false
        
        newHabit.colorRed = Float(pickedColor.components.red)
        newHabit.colorBlue = Float(pickedColor.components.blue)
        newHabit.colorGreen = Float(pickedColor.components.green)
        newHabit.colorAlpha = Float(pickedColor.components.alpha)
        
        newHabit.completionSecondsProgress = completionSecondsProgress
        newHabit.completionMinutesProgress = completionMinutesProgress
        newHabit.completionHoursProgress = completionHoursProgress
        
        newHabit.totalLoggedTime = 0
        

        try? moc.save()
        
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
