//
//  ProgressView.swift
//  MyHabitPal
//
//  Created by Artem on 13/12/2022.
//

import SwiftUI
import Foundation
import CoreData


struct ProgressView: View {

    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var habits: FetchedResults<Habit>
    
    @State var habit: Habit
    
    var body: some View {
        VStack {
                 ZStack {
                     // 2
                     ZStack {
                         Circle()
                             .stroke(
                                 Color.gray.opacity(0.5),
                                 lineWidth: 5
                             )
                         Circle()
                             .trim(from: 0, to: habit.completionProgress)
                             .stroke(
                                (Color(red: CGFloat(habit.colorRed), green: CGFloat(habit.colorGreen), blue: CGFloat(habit.colorRed))),
                                 style: StrokeStyle(
                                     lineWidth: 5,
                                     lineCap: .round
                                 )
                             )
                             .rotationEffect(.degrees(-90))
                             // 1
                             .animation(.easeOut, value: habit.completionProgress)

                     }
                     // 3
                 }
                 
             }
         }
         
}

//struct ProgressView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressView()
//    }
//}
