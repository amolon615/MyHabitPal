//
//  CompletionView-View.swift
//  MyHabitPal
//
//  Created by Artem on 07/12/2022.
//

import SwiftUI

struct CompletionView_View: View {
    @Environment(\.managedObjectContext) var moc
    
    let columns = 19
    let rows = 7
    let size = CGSize(width: 10, height: 10)
    
    @State var habit: Habit
    
    var body: some View {
        VStack{
            HStack {
                ForEach(0..<columns, id: \.self) { column in
                    VStack {
                        ForEach(0..<self.rows, id: \.self) { row in
                            RoundedRectangle(cornerRadius: 3)
                                .frame(width: self.size.width, height: self.size.height)
                                .shadow(radius: 5)
                                .foregroundColor(self.colorForRectangle(row: row, column: column))
                        }
                    }
                }
            }
        }

    }
    
    func colorForRectangle(row: Int, column: Int) -> Color {
        
        let rectColor = Color (.sRGB, red:CGFloat(habit.colorRed), green: CGFloat(habit.colorGreen), blue: CGFloat(habit.colorBlue))
        
        
        let index = (column * rows) + row
        if index <= habit.loggedDays {
            return rectColor
        } else {
            return .gray
        }
    }
}

