//
//  ContentView.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI
struct ContentView: View {
    var tosAccepted = UserDefaults.standard.bool(forKey: "tosAccepted")

    @State var accepted = false
    var body: some View {
        NavigationStack{
            VStack {
                if tosAccepted && tosAccepted == true {

             
                                    MainTabBarView()
            
                                        .preferredColorScheme(.light)
                                
           
                }else{
                    
                    TermsOfServiceView {
                        UserDefaults.standard.set(true, forKey: "tosAccepted")
                        accepted = true
                    } onDecline: {
                        
                    }
                    .preferredColorScheme(.light)

                    
                }
            }.navigationDestination(isPresented: $accepted) {

                                MainTabBarView()
                                    .preferredColorScheme(.light)
                            


            }
        }
    }
}

#Preview {
    ContentView()
}
