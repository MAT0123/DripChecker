//
//  AccountSettingsView.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI
import StoreKit

struct AccountSettingsView: View {
    @State private var notificationsEnabled = true
    @State private var shareAnalytics = false
    @State private var showDeleteAccount = false
    @State private var showFaq = false
    @State private var showTos = false
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.95, blue: 0.97),
                        Color(red: 0.90, green: 0.90, blue: 0.95)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                       
                        VStack(spacing: 20) {
                            
                            SettingsSection(title: "Support") {
                                
                                SettingsRow(icon: "questionmark.circle.fill",
                                            title: "Help & FAQ",
                                            subtitle: "Get answers to common questions", isDestructive: false) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                } action: {
                                    showFaq.toggle()
                                }


                        
                                .sheet(isPresented: $showFaq) {
                                    HelpFAQView()
                                }
                                
                                SettingsRow(
                                    icon: "envelope.fill",
                                    title: "Contact Support",
                                    subtitle: "Reach out to our team"
                                ) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                } action: {
                                    let url = "mailto:matthewaureliustjoa@gmail.com"
                                    
                                    UIApplication.shared.open(URL(string: url)!)
                                }
                                
                                SettingsRow(
                                    icon: "star.fill",
                                    title: "Rate App",
                                    subtitle: "Share your experience"
                                ) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                        
                                } action: {
                                    let scene = UIApplication.shared.connectedScenes.first
                                    
                                    AppStore.requestReview(in: scene! as! UIWindowScene)
                                }
                                
                                
                                
                            }
                            
                            SettingsSection(title: "Legal") {
                                SettingsRow(
                                    icon: "doc.text.fill",
                                    title: "Terms of Service",
                                    subtitle: "Read our terms"
                                ) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                } action: {
                                    showTos.toggle()
                                }
                                .sheet(isPresented: $showTos) {
                                    TermsOfServiceView(showAccept: false) {
                                        
                                    } onDecline: {
                                        
                                    }

                                }
                                
                                SettingsRow(
                                    icon: "lock.fill",
                                    title: "Privacy Policy",
                                    subtitle: "How we protect your data"
                                ) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                } action: {
                                    
                                }
                            }
                            
                            // Danger Zone
                            SettingsSection(title: "Data") {
                                SettingsRow(
                                    icon: "trash.fill",
                                    title: "Delete All Data",
                                    subtitle: "Permanently delete your analysis",
                                    isDestructive: true
                                ) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                } action: {
                                    showDeleteAccount = true
                                    SwiftDataManager.shared.deleteAll()
                                }
                                
                               
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // App Version
                        Text("DripCheck v1.0.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Setting")
            .navigationBarTitleDisplayMode(.large)
            .alert("Data Deleted", isPresented:$showDeleteAccount) {
                
            }
        }
    }
}
