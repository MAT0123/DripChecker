//
//  ContentView.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI
struct ContentView: View {
    @AppStorage("tosAccepted") private var tosAccepted = false
    @State var accepted = false
    var body: some View {
        NavigationStack{
                VStack {
                    if tosAccepted {
                        MainTabBarView()
                            .preferredColorScheme(.light)
                    }else{
                        TermsOfServiceView {
                            tosAccepted = true
                            accepted = true
                        } onDecline: {
                            
                        }
                        .preferredColorScheme(.light)
                    }
                }.navigationDestination(isPresented: $accepted) {
                    MainTabBarView()
                        .preferredColorScheme(.light)
                        .navigationBarBackButtonHidden()
           
                }
        }
    }
}

#Preview {
    ContentView()
}
