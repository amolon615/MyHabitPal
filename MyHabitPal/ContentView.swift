//
//  ContentView.swift
//  MyHabitPal
//
//  Created by Artem on 06/12/2022.
//

import SwiftUI
import CoreData
import Charts
import Combine
import PhotosUI
import UIKit



struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var habits: FetchedResults<Habit>
 
    @State private var addHabit = false
    @State private var showSettings = false
    @State private var showLogHabit = false
    
    @State private var step1 = "false"
    @State private var step2 = "false"
    @State private var step3 = "false"
    
    @State var userName = ""
   
    
    @State private var buttonDisable = false
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
    
    @State private var image: Image?
    @State private var selectedImage: Data?
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isSelectedPhoto = false
    

    
    
    @State private var showPhotoPicker = false
    
    func animatableGradient(fromGradient: Gradient, toGradient: Gradient, progress: CGFloat) -> some View {
        self.modifier(AnimatableGradientModifier(fromGradient: fromGradient, toGradient: toGradient, progress: progress))
    }
    
    @State private var progress: CGFloat = 0
       let gradient1 = Gradient(colors: [.purple, .yellow])
       let gradient2 = Gradient(colors: [.blue, .purple])

    @State private var offset: CGFloat = 0
    
    @State private var scale: CGFloat = 1
    
    @State private var isPresentingHabit: Habit? = nil
    
    var body: some View {
                NavigationView{
                    ZStack{
                        GradientView()
                        VStack{
                            ZStack{
                                VStack(alignment: .leading){
                                        Text("Today's \(Date.now.formatted(.dateTime.day().month().year()))")
                                        .padding(.leading)
                                        .foregroundColor(.black.opacity(0.7))
                                    HStack{
                                        VStack(alignment: .leading){
                                                Image("avatar")
                                                    .resizable()
                                                    .frame(width: 70, height: 70)
                                                    .clipShape(Circle())
                                        }
                                        VStack(alignment: .leading){
                                            VStack(alignment: .leading){
                                                Text("Hello, \(userName)")
                                                if habits.count > 1{
                                                    Text("You've got \(habits.count) habits")
                                                } else {
                                                    Text("You've got \(habits.count) habit")
                                                }
                                            }
                                            .foregroundColor(.black.opacity(0.7))
                                           
                                        }
                                        .frame(width: 200, height: 50)
                                        .padding()
                                        .onTapGesture {
                                            addHabit = true
                                        }
                                      
                                       
                                    }
                                }
                                .frame(height: 150)
                                
                            }
                            .padding()
                               .frame(width: 350, height: 150)
                               .background(colorScheme == .dark ? .gray.opacity(0.7) : .white)
                               .cornerRadius(10)
                               .shadow(radius: 5)
                            
                            
                            
                                
                            List{
                                ForEach(habits, id:\.name){ habit in
                                    VStack{
                                        HStack{
                                            NavigationLink(destination: {
                                                HabitDetailedView_View(habit: habit, loggedDays: Int(habit.loggedDays))
                                            }, label: {
                                                HStack{
                                                    Image(systemName: habit.habitIcon ?? "star")
                                                        .foregroundColor(Color(red: CGFloat(habit.colorRed), green: CGFloat(habit.colorGreen), blue: CGFloat(habit.colorBlue)))
                                                        .font(.system(size: 20))
                                                        .padding(.leading)
                                                    Text(habit.name ?? "Unknown")
                                                    Spacer()
                                                    ProgressView(width: 7, circleProgress: habit.completionProgress, color: Color(red: CGFloat(habit.colorRed), green: CGFloat(habit.colorGreen), blue: CGFloat(habit.colorBlue)), frameWidth: 40.0, frameHeight: 30.0)
                                                        .padding()
                                                }
                                            })
                                        }
                                    }
                                    .listRowSeparator(.hidden)
                                }
                                .onDelete(perform: deleteHabits)
                            }
                            
                            .scrollContentBackground(.hidden)    
                        }
                       
                        }
                    .navigationTitle("Summary")
                    .toolbar {
                        ToolbarItem{
                            if habits.isEmpty {
                                Button{
                                    addHabit = true
                                    HapticManager.instance.impact(style: .light)
                                } label: {
                                    Label("Add new habit", systemImage: "plus")
                                        .foregroundColor(.white)
                                }
                            } else {
                                Button{
                                    addHabit = true
                                    HapticManager.instance.impact(style: .light)
                                } label: {
                                    Label("Add new habit", systemImage: "plus")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            if habits.isEmpty {
                                Button{
                                    showSettings = true
                                    HapticManager.instance.impact(style: .light)
                                } label: {
                                    Label("Add new habit", systemImage: "gear")
                                        .foregroundColor(.white)
                                }
                            } else {
                                Button{
                                    showSettings = true
                                    HapticManager.instance.impact(style: .light)
                                } label: {
                                    Label("Add new habit", systemImage: "gear")
                                        .foregroundColor(.white)
                                }
                        }
                            
                        }
                    }
                   
                   
                   
                   
                }
                .onAppear{
                    if let loadedUsername = loadString(key: "username"){
                        userName = loadedUsername
                    }
                }

            .sheet(isPresented: $addHabit) {
                    AddHabitView()
                }
                .sheet(isPresented: $showSettings) {
                    Settings_View()
                }
             
            
       
    }
    
    func deleteHabits(at offsets: IndexSet) {
        for offset in offsets {
            let habit = habits[offset]
            moc.delete(habit)
            HapticManager.instance.impact(style: .light)
        }
        
        try? moc.save()
    }
    
    //save name to userDefaults
        func saveData(key: String, value: String) {
            UserDefaults.standard.set(value, forKey: key)
        }
    
    //load name from userDefaults
    func loadString(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
   
    
    //save user's photo to disk
    func saveImageToDisk(image: UIImage, fileName: String) {
        if let data = image.pngData() {
            let fileURL = getFileURL(fileName: fileName)
            do {
                try data.write(to: fileURL)
            } catch {
                print("Error saving image to disk: ", error)
            }
        }
    }
    
    //load user's photo from disk
    func loadImageFromDisk(fileName: String) -> UIImage? {
        let fileURL = getFileURL(fileName: fileName)
        do {
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data)
        } catch {
            print("Error loading image from disk: ", error)
        }
        return nil
    }
    
    //get filepath url to save photo
    func getFileURL(fileName: String) -> URL {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL.appendingPathComponent(fileName)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
