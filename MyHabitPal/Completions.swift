//
//  Completions.swift
//  MyHabitPal
//
//  Created by Artem on 07/12/2022.
//

import SwiftUI

//
//  LazyVGridBootcamp.swift
//  workoutApp
//
//  Created by Artem on 14/11/2022.
//

import SwiftUI

struct RoundedRectangleGrid: View {
    let columns = 15
    let rows = 7
    let size = CGSize(width: 10, height: 10)
    
    @State private var variable = 0
    
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
        let index = (column * rows) + row
        if index <= variable {
            return .blue
        } else {
            return .gray
        }
    }
}



struct LazyVGridBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectangleGrid()
    }
}

