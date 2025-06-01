//
//  AnalysisResult.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI


// MARK: - Single Outfit Analysis View

struct SingleOutfitAnalysisView: View {
    let analysis: SingleOutfitAnalysis
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with overall score
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(.purple)
                        .font(.title2)
                    
                    Text("Fashion Analysis")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                // Overall Impression
                Text(analysis.overallImpression)
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
            
            // Fashion Score Card
            FashionScoreCard(score: analysis.fashionScore)
            
            // Style Analysis Card
            StyleAnalysisCard(styleAnalysis: analysis.styleAnalysis)
            
            // Color Coordination Card
            ColorCoordinationCard(colorCoordination: analysis.colorCoordination)
            
            // Fit & Silhouette Card
            FitSilhouetteCard(fitAndSilhouette: analysis.fitAndSilhouette)
            
            // Styling Tips Card
            StylingTipsCard(tips: analysis.stylingTips)
            
            // Strengths & Areas for Improvement
            StrengthsImprovementCard(
                strengths: analysis.strengths,
                improvements: analysis.areasForImprovement
            )
            
            // Action Buttons
            ActionButtonsView()
        }
    }
}

