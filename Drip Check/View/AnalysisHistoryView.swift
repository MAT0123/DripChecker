//
//  AnalysisHistoryView.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI
import SwiftData

struct AnalysisHistoryView: View {
    @State private var showDeleteAlert = false
    @State private var itemToDelete: AnalysisHistoryItem?
    @Binding private var selectedTab:Int
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \AnalysisHistoryItem.date, order: .reverse) var allItems: [AnalysisHistoryItem]
    
    init(tabSelection: Binding<Int>){
        self._selectedTab = tabSelection

    }
    var body: some View {
        NavigationView {
            ZStack {

                ScrollView{
                    if (allItems.isEmpty) {
                        
                        emptyStateView
                    } else {
                            LazyVStack(spacing: 16) {
                                ForEach(allItems) { item in
                                    AnalysisHistoryCard(
                                        item: item,
                                        onDelete: {
                                            itemToDelete = item
                                            showDeleteAlert = true
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                            .navigationTitle("Fashion History")
                                .navigationBarTitleDisplayMode(.large)
                        
                    }
                }.navigationTitle("Fashion History")
                    .navigationBarTitleDisplayMode(.large)

                    .alert("Delete Analysis", isPresented: $showDeleteAlert) {
                        Button("Delete", role: .destructive) {
                            if let item = itemToDelete {
                                deleteAnalysis(item)
                            }
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Are you sure you want to delete this fashion analysis?")
                    }
                
                
            }
            
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.badge.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.purple.opacity(0.6))
            
            Text("No Fashion History Yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Your fashion analyses will appear here after you create them")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
               
                selectedTab = 0
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Create First Analysis")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .pink]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
        }
    }
    

    
    private func deleteAnalysis(_ item: AnalysisHistoryItem) {
        withAnimation {
            SwiftDataManager.shared.delete(id: item.id)
        }
    }
}
