//
//  AddHabit.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI
import SFSymbolsPicker

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
 
    @State private var habitIcon = ""
    @State private var iconPicker = false
    
    @State private var habitColor = Color.red

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
            NavigationView {
                Form{
                    Section{
                        TextField("Name of habit", text: $name)
                        TextField("Description", text: $about)
                        
                    } header: {
                        Text("Give your desired habit a name.")
                            .foregroundColor(.blue)
                    }
                    Section {
                            Slider(value: $targetDays, in: 1...100, step: 1)
                        Text("\(String(format: "%.0f", targetDays)) days selected")
                            .multilineTextAlignment(.center)
                            
                           //add a tip, to put at least 14 days for habit forming
                            Toggle("Log time?", isOn: $logMinutes)
                        
                    } header: {
                        Text("Select target amount of days")
                    }
                    //select an icon
                    Section {
                        Button(action: {
                                    withAnimation {
                                        iconPicker.toggle()
                                    }
                                }, label: {
                                    HStack {
                                        Text("Select icon")
                                        Spacer()
                                        Image(systemName: habitIcon)
                                    }
                                })
                                
                                SFSymbolsPicker(isPresented: $iconPicker, icon: $habitIcon, category: .habit, axis: .vertical, haptic: true)
                        
                    } header: {
                        Text("Customise your experience")
                    }
                    //select a color
                    Section{
                        ColorPicker("Set the color", selection: $habitColor)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
                        
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading, content: {
                        Button("Cancel", role: .destructive){
                            dismiss()
                        }
                    })
                    ToolbarItem(placement: .bottomBar) {
                        Button("Add habit"){
                            add()
                        }
                        .frame(width: 100, height: 40)
                        .foregroundColor(.white)
                        .background(addDisabled ? .gray: .blue)
                        .cornerRadius(10)
                        .disabled(addDisabled)
                    }
   
                }
               
        }
    }
    
    func add(){
        let newHabit = Habit(context: moc)
        
        
        let date = Date.now
        
        print(date)
        
        newHabit.id = UUID()
        newHabit.name = name
        newHabit.about = about
        newHabit.completionType = completionType
        newHabit.loggedDays = Int32(loggedDays)
        newHabit.actualDate = actualDate
        newHabit.currentStreak = Int32(currentStreak)
        newHabit.habitIcon = habitIcon
        newHabit.maxStreak = Int32(maxStreak)
        newHabit.logMinutes = logMinutes
        newHabit.loggedHours = Int32(loggedHours)
        newHabit.loggedMinutes = Int32(loggedMinutes)
        newHabit.loggedSeconds = Int32(loggedSeconds)
        
        try? moc.save()
        dismiss()
    }
}

struct AddHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
    }
}
