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
 
    @State private var trackedTime = 0
    @State private var completedDays = 0
    @State private var strike = 0
    @State private var targetDays = 1
    
    
    let habitTypes = ["📚Study", "❤️Health", "🏅Sport" , "🧶Hobby"]
    @State private var habitType = "❤️Health"
    
    
    let completionTypes = ["⏰Track minutes", "🗓️Track days"]
    @State private var completionType = "⏰Track days"
    
    
    
    var body: some View {
            NavigationView {
                ZStack{
                    VStack{
                        TextField("Name of habit", text: $name)
                        TextField("Description", text: $about)
                        
                        Picker("Select type of habit", selection: $habitType) {
                            ForEach(habitTypes, id:\.self) {
                                Text($0)
                            }
                        }.pickerStyle(.segmented)
                        
                        Picker("Select type of tracking", selection: $completionType) {
                            ForEach(completionTypes, id:\.self) {
                                Text($0)
                            }
                        }.pickerStyle(.segmented)
                        
                        if completionType == "⏰Track days" {
                            VStack{
                                Text("Select desired number of days")
                                Stepper("Days \(targetDays)", value: $targetDays, in: 1...1000)
                            }
                        }
                    }
                          
                    VStack{
                        Spacer()
                        HStack {
                            Spacer()
                            //disable addButton if no data
                            //change color of button is disabled
                            Button {
                                add()
                            } label: {
                                Image(systemName: "plus")
                                    .padding()
                                    .background(.black.opacity(0.75))
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .clipShape(Circle())
                                    .padding(.trailing)
                            }
                        }
                    }
                }
        }
    }
    
    func add(){
        let newHabit = Habit(context: moc)
        newHabit.id = UUID()
        
        newHabit.name = name
        newHabit.about = about
        newHabit.completionType = completionType
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
