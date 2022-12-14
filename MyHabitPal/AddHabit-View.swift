//
//  AddHabit.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI
import SFSymbolsPicker
import CoreData

class HapticManager {
    static let instance = HapticManager() // Singleton
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct AddHabitView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var about = ""
    
    var addDisabled: Bool {
        if name == "" {
            return true
        } else {
            return false
        }
    }
 
    @State private var habitIcon = "star"
    @State private var iconPicker = false
    

    
    @State private var myColor = Color(.sRGB, red:0.4, green: 0.3, blue: 0.4)
    
    @State var cgcolorRed: CGFloat = 0.0
    @State var cgcolorGreen: CGFloat  = 0.0
    @State var cgcolorBlue: CGFloat = 0.0
    
    

    @State private var targetDays = 14.0
    
    @State private var loggedDays = 0
    
    //timer block
    @State private var logMinutes = false
    @State private var loggedHours = 0
    @State private var loggedMinutes = 0
    @State private var loggedSeconds = 0
    
    @State var completionProgress: Double = 0

    
    
    var actualDate = Date.now.formatted(date: .long, time: .omitted)
    
    
    func animatableGradient(fromGradient: Gradient, toGradient: Gradient, progress: CGFloat) -> some View {
        self.modifier(AnimatableGradientModifier(fromGradient: fromGradient, toGradient: toGradient, progress: progress))
    }
    
    @State private var progress: CGFloat = 0
       let gradient1 = Gradient(colors: [.purple, .yellow])
       let gradient2 = Gradient(colors: [.blue, .purple])
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack{
            Rectangle()
                .animatableGradient(fromGradient: gradient1, toGradient: gradient2, progress: progress)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
                        self.progress = 1.0
                    }
                }
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
                VStack (spacing: 0){ //first section
                  
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colorScheme == .dark ? .gray : .white)
                            .frame(width: 350, height: 100)
                            .shadow(radius: 10)
                            .padding()
                            .opacity(0.7)
                        VStack{
                            TextField("Enter your habit's name", text: $name)
                                .padding()
                                .padding(.leading)
                                .foregroundColor(.black)
                                .frame(width: 350, height: 40)
                                .disableAutocorrection(true)
                            TextField("Describe it", text: $about)
                                .padding()
                                .padding(.leading)
                                .frame(width: 350, height: 40)
                                .disableAutocorrection(true)
                        }
                        
                    }
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colorScheme == .dark ? .gray : .white)
                            .frame(width: 350, height: 190)
                            .shadow(radius: 10)
                            .padding()
                            .opacity(0.7)
                        VStack{
                            HStack{
                                Text(String(format: "%g", targetDays))
                                Text("days selected")
                                
                            }
                            Slider(value: $targetDays, in: 1...365, step: 1)
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
                            .frame(width: 350, height: 100)
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
                            
                            ColorPicker("Select color", selection: $myColor)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .frame(width: 310, height: 20)
                                .padding()
                                .padding(.leading)
                          
                        }
                    }
                }
                
                .sheet(isPresented: $iconPicker) {
                    SFSymbolsPicker(isPresented: $iconPicker, icon: $habitIcon, category: .habit, axis: .vertical, haptic: true)
                }
            }
            VStack{
                Spacer()
                HStack{
                    withAnimation(.easeInOut(duration: 2)) {
                        Button {
                            add()
                            HapticManager.instance.notification(type: .success)
                    } label: {
                        HStack{
                            Text("Save habit & start tracking")
                                .foregroundColor(.white)
                            Image(systemName: "hand.tap")
                                .foregroundColor(.white)
                        }
                    }
                        
                    .frame(width:320, height: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .opacity(0.8)
                    .padding()
                    }
                    
                }
            }
           
        }
        
    }
    
    func add(){
        let newHabit = Habit(context: moc)
        
        let date = Date.now
        
        let pickedColor = UIColor(myColor)
        print(date)
        
        newHabit.id = UUID()
        newHabit.name = name
        newHabit.about = about
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

        
        try? moc.save()
        dismiss()
    }
}

struct AddHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
    }
}
