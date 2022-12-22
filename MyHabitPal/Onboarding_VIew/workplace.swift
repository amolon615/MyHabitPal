//
//  workplace.swift
//  MyHabitPal
//
//  Created by Artem on 22/12/2022.
//

import SwiftUI

struct workplace: View {
    
    var numbers = [1, 2, 3, 4]
    @State var selectedNumber = 1
    @State var loggedNumber = 0
    
    @State var animated = false
    var body: some View {
        
        VStack{
            HStack{
                ForEach(numbers, id:\.self){number in
                    Button("\(number)"){
                        selectedNumber = number
                        animated = true
                    }
                    .frame(width: 50, height: 50)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .scaleEffect(animated ? 0.6 : 1)
                    .onChange(of: animated) { newValue in
                        withAnimation {
                            animated = false
                        }
                    }
                }
            }
            HStack{
                Text("Selected number is \(selectedNumber)")
                Button("save number"){
                    loggedNumber += selectedNumber
                    selectedNumber = 1
                }
            }
            HStack{
                Text("Logged number is \(loggedNumber)")
            }
        }
       
       
    }
}

struct workplace_Previews: PreviewProvider {
    static var previews: some View {
        workplace()
    }
}
