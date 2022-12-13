//
//  Add.swift
//  MyHabitPal
//
//  Created by Artem on 09/12/2022.
//

import SwiftUI
import SFSymbolsPicker
import CoreData

struct Add: View {
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
    
    @State private var infiniteHabit = false
    
    
    var actualDate = ""
    
    
    let completionTypes = ["⏰Track minutes", "🗓️Track days"]
    @State private var completionType = "🗓️Track days"
    
    var body: some View {
        ZStack{
            VStack {//column
                VStack (spacing: 0){ //first section
                    ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: .infinity, height: 40)
                            .shadow(radius: 10)
                            .padding()
                        TextField("Type habit's name", text: $name)
                            .padding()
                            .padding(.leading)
                    }
                    ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: .infinity, height: 40)
                            .shadow(radius: 10)
                            .padding()
                        TextField("Describe it", text: $about)
                            .padding()
                            .padding(.leading)
                    }
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: .infinity, height: 40)
                        .shadow(radius: 10)
                        .padding()
                        Toggle("Log time?", isOn: $logMinutes)
                            .padding(30)
                            .foregroundColor(.secondary)
                            
                    }
                }
                VStack (spacing: 10){
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: .infinity, height: 40)
                        .shadow(radius: 10)
                        .padding()
                      
                    }
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: .infinity, height: 40)
                        .shadow(radius: 10)
                        .padding()
                        ColorPicker("Select color", selection: $myColor)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                
            }
        }
        .sheet(isPresented: $iconPicker) {
            SFSymbolsPicker(isPresented: $iconPicker, icon: $habitIcon, category: .habit, axis: .vertical, haptic: true)
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

struct Add_Previews: PreviewProvider {
    static var previews: some View {
        Add()
    }
}
