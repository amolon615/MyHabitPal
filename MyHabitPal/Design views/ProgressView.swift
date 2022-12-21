//
//  ProgressView.swift
//  MyHabitPal
//
//  Created by Artem on 13/12/2022.
//

import SwiftUI
import Foundation

struct ProgressView: View {

    
     var width: CGFloat
     var circleProgress: CGFloat
     var color: Color
     var frameWidth: CGFloat
     var frameHeight: CGFloat
    
    var body: some View {
        VStack {
                 ZStack {
                     // 2
                     ZStack {
                         Circle()
                             .stroke(
                                (color.opacity(0.2)),
                                lineWidth: width
                             )
                         Circle()
                             .trim(from: 0, to: circleProgress)
                             .stroke(
                                (color),
                                 style: StrokeStyle(
                                     lineWidth: width,
                                     lineCap: .round
                                 )
                             )
                             .rotationEffect(.degrees(-90))
                             .animation(.easeOut, value: circleProgress)

                     }
                 }
                 
             }
        .frame(width: frameWidth, height: frameHeight)
        .padding()
   }
       
         
}


