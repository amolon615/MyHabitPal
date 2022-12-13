//
//  animations_test.swift
//  MyHabitPal
//
//  Created by Artem on 13/12/2022.
//

import SwiftUI

struct animations_test: View {
    @State private var offset: CGFloat = 0

      var body: some View {
          Image("bot_main")
              .offset(x: 0, y: offset)
              .animation(.interpolatingSpring(stiffness: 100, damping: 10))
              .onAppear() {
                  Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                      self.offset = self.offset == 0 ? 5 : 0
                  }
              }
      }
}

struct animations_test_Previews: PreviewProvider {
    static var previews: some View {
        animations_test()
    }
}
