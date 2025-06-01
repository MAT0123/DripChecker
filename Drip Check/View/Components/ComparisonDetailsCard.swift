//
//  ComparisonDetailsCard.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI

struct ComparisonDetailsCard: View {
    let comparison: ComparisonDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Style Analysis
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                    
                    Text("Style Comparison")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                Text(comparison.styleAnalysis)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            // Color Coordination
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "paintpalette.fill")
                        .foregroundColor(.purple)
                        .font(.title3)
                    
                    Text("Color Analysis")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                Text(comparison.colorCoordination)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            // Improvement Tips
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.orange)
                        .font(.title3)
                    
                    Text("Improvement Tips")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                ForEach(Array(comparison.improvementTips.enumerated()), id: \.offset) { index, tip in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\(index + 1).")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                        
                        Text(tip)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}
