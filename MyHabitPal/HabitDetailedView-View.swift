//
//  HabitDetailedView-View.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI

struct HabitDetailedView_View: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var habits: FetchedResults<Habit>
    
    @State var date = Date.now
    @State var completedDays = 1
    
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Today's \(date.formatted())")
                Button("Log an activity today") {
                    //add counter
                    completedDays += 1
                    //disable button if today was completed
                }
            }
            .navigationTitle("Log")
        }
    }
}

struct HabitDetailedView_View_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailedView_View()
    }
}
