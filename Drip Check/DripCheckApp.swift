//
//  DripCheckApp.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI
import SwiftData

//class AppDelegate: NSObject, UIApplicationDelegate {
//func application(_ application: UIApplication,
//                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//  FirebaseApp.configure()
//  return true
//}
//}


@main
struct DripCheckApp: App {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var networkManager = NetworkManager()
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .modelContainer(for: AnalysisHistoryItem.self)
                .environmentObject(networkManager)

        }
    }
}
