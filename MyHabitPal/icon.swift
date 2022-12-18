//
//  icon.swift
//  MyHabitPal
//
//  Created by Artem on 21/12/2022.
//

import SwiftUI

struct icon: View {
    @State var options =  ["bed.double", "powersleep", "bed.double.fill", "brain", "brain.head.profile", "carrot", "birthday.cake", "wineglass", "wineglass.fill", "cup.and.saucer", "cup.and.saucer.fill", "fork.knife", "pencil", "highlighter", "figure.disc.sports", "figure.run", "figure.run.circle.fill", "figure.pool.swim","figure.outdoor.cycle", "bicycle", "figure.strengthtraining.functional", "sun.min", "pill", "pills", "x.squareroot" ]
    
    @State var selectedIcon = "bicycle"
    
    var body: some View {
        Picker("Pick an icon", selection: $selectedIcon) { // 3
            ForEach(options, id: \.self) { item in // 4
              Text(Image(systemName: selectedIcon))
                .rotationEffect(Angle(degrees: 90))// 5
            }
        }
        .pickerStyle(.wheel)
        .labelsHidden()
        .rotationEffect(Angle(degrees: -90))
        .frame(maxWidth: 300, maxHeight: 50)
        .clipped()
    }
}

struct icon_Previews: PreviewProvider {
    static var previews: some View {
        icon()
    }
}
