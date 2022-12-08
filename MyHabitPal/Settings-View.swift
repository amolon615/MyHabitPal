//
//  Settings-View.swift
//  MyHabitPal
//
//  Created by Artem on 08/12/2022.
//

import SwiftUI
import SafariServices

struct Settings_View: View {
    @State private var chooseTheme = false
    @State private var showPrivacy: Bool = false
    @State private var showTOS: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Color theme")
                    Text("Re-launch onboarding")
                }
                Section {
                    Text("Privacy policy")
                        .onTapGesture {
                            showPrivacy.toggle()
                        }
                    Text("Terms of use")
                        .onTapGesture {
                            showTOS.toggle()
                        }
                }
                Section {
                    Text("Leave feadback")
                    Text("Rate the app")
                }
            }
            .navigationTitle("Settings")
            }
        .sheet(isPresented: $showPrivacy){
        SFSafariViewWrapper(url: URL(string:"https://apple.com")!)
        }
        
        .sheet(isPresented: $showTOS){
        SFSafariViewWrapper(url: URL(string:"https://apple.com")!)
        }
        }
       
    
    }

struct SFSafariViewWrapper: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
    }
}


struct Settings_View_Previews: PreviewProvider {
    static var previews: some View {
        Settings_View()
    }
}
