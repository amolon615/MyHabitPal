////
////  Step1_Username.swift
////  MyHabitPal
////
////  Created by Artem on 20/12/2022.
////
//
//import SwiftUI
//import Combine
//
//struct Step1_Username: View {
//    @Environment(\.colorScheme) var colorScheme
//    @State private var step1 = "false"
//    @State private var offset: CGFloat = 0
//    
//    @State var userName = ""
//    let userNameLimit = 15
//    
//    
//    var body: some View {
//        VStack{
//            Image("bot_main")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100)
//                .padding()
//                .shadow(color: .gray, radius: 10, x: 0, y: 5)
//                .offset(x: 0, y: offset)
//                .onAppear() {
//            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
//                withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)){
//                    self.offset = self.offset == 0 ? 5 : 0
//                }
//            }
//        }
//    
//                ZStack{
//                    Rectangle()
//                        .frame(width: 170, height: 50)
//                        .background(colorScheme == .dark ? .gray : .white)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .opacity(0.7)
//                    TextField("Enter your name", text: $userName)
//                        .onReceive(Just(userName)) { _ in limitText(userNameLimit) }
//                        .frame(width: 130, height: 50)
//                        .padding()
//                        .foregroundColor(colorScheme == .dark ? .black : .black)
//
//                }
//               
//            Button {
//                saveData(key: "userName", value: userName)
//                step1 = "true"
//                saveData(key: "step1", value: step1)
//            } label: {
//                Label("Save & Next", systemImage: "square.and.arrow.down")
//                    
//            }
//            .disabled(userName == "" ? true : false)
//            .frame(width: 170, height: 50)
//            .background(.white)
//            .cornerRadius(10)
//        }
//
//        
//    }
//    
//    //save name to userDefaults
//        func saveData(key: String, value: String) {
//            UserDefaults.standard.set(value, forKey: key)
//        }
//    
//    //load name from userDefaults
//    func loadString(key: String) -> String? {
//        return UserDefaults.standard.string(forKey: key)
//    }
//    //limit name field by symbols
//    func limitText(_ upper: Int) {
//           if userName.count > upper {
//               userName = String(userName.prefix(upper))
//           }
//       }
//}
//
//struct Step1_Username_Previews: PreviewProvider {
//    static var previews: some View {
//        Step1_Username()
//    }
//}
