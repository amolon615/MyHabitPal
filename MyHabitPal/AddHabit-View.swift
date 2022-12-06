//
//  AddHabit.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI

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
 

    @State private var targetDays = 14.0
    @State private var loggedDays = 0
    @State private var strike = 0
    
    @State private var logMinutes = false
    @State private var loggedMinutes = 0
    
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
                        
                    }
                    //select a color
                    Section{
                        
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
        newHabit.strike = Int32(strike)
        
        try? moc.save()
        dismiss()
    }
}

struct AddHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
    }
}
