//
//  MainTabBarView.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI
import StoreKit
struct MainTabBarView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var networkManager:NetworkManager
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            ReviewSelectionView(networkManager: networkManager, onSingleReview: { image in
                
            }, onComparison: { image in
                
            })
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            // Analysis History Tab
            AnalysisHistoryView(tabSelection: $selectedTab)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "clock.fill" : "clock")
                    Text("History")
                }
                .tag(1)
            
            // Account Settings Tab
            AccountSettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "gear.circle.fill" : "gear")
                    Text("Setting")
                }
                .tag(2)
        }
        .accentColor(.purple)
    }
}


