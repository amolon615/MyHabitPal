////
////  Step2_UserPhoto.swift
////  MyHabitPal
////
////  Created by Artem on 20/12/2022.
////
//
//import SwiftUI
//
//struct Step2_UserPhoto: View {
//    var body: some View {
//        VStack{
//            Spacer()
//         
//            PhotosPicker(
//                selection: $selectedItem,
//                matching: .images,
//                photoLibrary: .shared()) {
//                    ZStack{
//                        if isSelectedPhoto == false {
//                            Circle()
//                                .frame(width: 100)
//                                .foregroundColor(.white.opacity(0.7))
//                            Image(systemName: "photo.fill")
//                                .font(.largeTitle)
//                                .foregroundColor(.blue)
//                        } else {
//                            if isSelectedPhoto {
//                                ImageView(image: loadImageFromDisk(fileName: userName) ?? UIImage(named: "avatar")!)
//                                    .frame(width: 100, height: 100)
//                                    .clipShape(Circle())
//                            }
//                        }
//                           
//                    }
//                }
//                .onChange(of: selectedItem) {newItem in
//                    Task {
//                        if let data = try? await newItem?.loadTransferable(type: Data.self){
//                            selectedImage = data
//                            showPhotoPicker.toggle()
//                            print("photo picked")
//                            
//                          
//                            
//                           
//                            }
//                            
//                        }
//                    }
//                }
//            ZStack{
//                Rectangle()
//                    .frame(width: 150, height: 50)
//                    .foregroundColor(.white.opacity(0.7))
//                    .cornerRadius(10)
//                Text(isSelectedPhoto ? "Save" : "Skip")
//                    .foregroundColor(.secondary)
//            }
//            .padding()
//            .onTapGesture {
//                if let selectedImage = selectedImage {
//                    saveImageToDisk(image: UIImage(data: selectedImage)!, fileName: userName)
//                    
//                    print("Image saved")
////                                        step2 = "true"
////                                        saveData(key: "step2", value: step2)
//            }
//            
//          
//        }
//    }
//}
//
//struct Step2_UserPhoto_Previews: PreviewProvider {
//    static var previews: some View {
//        Step2_UserPhoto()
//    }
//}
