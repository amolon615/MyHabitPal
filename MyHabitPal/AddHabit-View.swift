//
//  AddHabit.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI
import SFSymbolsPicker
import CoreData

struct AddHabitView: View {
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
    @State private var currentStreak = 0
    @State private var maxStreak = 0
    
    //timer block
    @State private var logMinutes = false
    @State private var loggedHours = 0
    @State private var loggedMinutes = 0
    @State private var loggedSeconds = 0
    

    
    
    var actualDate = ""
    
    
    func animatableGradient(fromGradient: Gradient, toGradient: Gradient, progress: CGFloat) -> some View {
        self.modifier(AnimatableGradientModifier(fromGradient: fromGradient, toGradient: toGradient, progress: progress))
    }
    
    @State private var progress: CGFloat = 0
       let gradient1 = Gradient(colors: [.purple, .yellow])
       let gradient2 = Gradient(colors: [.blue, .purple])
    
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
                Text("Create new habit")
                    .padding(10)
               
                VStack (spacing: 0){ //first section
                    ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: 350, height: 40)
                            .shadow(radius: 10)
                            .padding()
                        TextField("Enter your habit's name", text: $name)
                            .padding()
                            .padding(.leading)
                            .foregroundColor(.black)
                    }
                    ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: 350, height: 40)
                            .shadow(radius: 10)
                            .padding()
                        TextField("Describe it", text: $about)
                            .padding()
                            .padding(.leading)
                    }
        
                    ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: 350, height: 120)
                            .shadow(radius: 10)
                            .padding()
                        VStack{
                            Text(String(format: "%g", targetDays) )
                                .padding()
                            Slider(value: $targetDays, in: 1...60)
                                .frame(width: 320)
                                .padding()
                                .padding(.leading)
                            
                                
                        }
                       
                    }
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: 350, height: 40)
                        .shadow(radius: 10)
                        .padding()
                        Toggle("Log time?", isOn: $logMinutes)
                            .padding(30)
                            .foregroundColor(.secondary)
                            
                    }
                }
                VStack (spacing: 0){
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: 350, height: 40)
                        .shadow(radius: 10)
                        .padding()
                        
                        withAnimation(.easeInOut(duration: 2)) {
                            Button{
                                iconPicker.toggle()
                            }label:{
                                HStack{
                                   
                                    Text("Choose icon")
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "\(habitIcon)")
                                        .padding(.leading)
                                        .foregroundColor(myColor)
                                    
                                }
                                .padding(30)
                            }
                        }
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: 350, height: 40)
                        .shadow(radius: 10)
                        .padding()
                        ColorPicker("Select color", selection: $myColor)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(30)
                    }
                }
                .sheet(isPresented: $iconPicker) {
                    SFSymbolsPicker(isPresented: $iconPicker, icon: $habitIcon, category: .habit, axis: .vertical, haptic: true)
                }
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    withAnimation(.easeInOut(duration: 2)) {
                        Button {
                            add()
                    } label: {
                        Image(systemName: "arrowtriangle.right.fill")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(width:50, height: 50)
                    .background(.blue)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .shadow(radius: 10)
                    .opacity(0.8)
                    .padding(.trailing)
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
        newHabit.currentStreak = Int32(currentStreak)
        newHabit.habitIcon = habitIcon
        newHabit.maxStreak = Int32(maxStreak)
        newHabit.logMinutes = logMinutes
        newHabit.loggedHours = Int32(loggedHours)
        newHabit.loggedMinutes = Int32(loggedMinutes)
        newHabit.loggedSeconds = Int32(loggedSeconds)
        
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
