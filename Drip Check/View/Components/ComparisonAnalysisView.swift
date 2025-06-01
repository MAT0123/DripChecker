//
//  ComparisonAnalysisView.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI

struct ComparisonAnalysisView: View {
    let analysis: ComparisonAnalysis
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                    
                    Text("Outfit Comparison")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                // Summary
                Text(analysis.summary)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            
            // Best Outfit Winner Card
            BestOutfitCard(bestOutfit: analysis.comparison.bestOutfit)
            
            // Individual Outfit Cards
            VStack(spacing: 16) {
                ForEach(analysis.outfits, id: \.outfitNumber) { outfit in
                    OutfitSummaryCard(outfit: outfit, isWinner: outfit.outfitNumber == analysis.comparison.bestOutfit.number)
                }
            }
            
            // Style & Color Comparison
            ComparisonDetailsCard(comparison: analysis.comparison)
            
            // Action Buttons
            ActionButtonsView()
        }
    }
}
