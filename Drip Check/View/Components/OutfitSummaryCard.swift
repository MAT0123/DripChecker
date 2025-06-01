//
//  OutfitSummaryCard.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI

struct OutfitSummaryCard: View {
    let outfit: OutfitSummary
    let isWinner: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Text("Outfit \(outfit.outfitNumber)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    if isWinner {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                            .font(.subheadline)
                    }
                }
                
                Spacer()
                
                Text(String(format: "%.1f", outfit.score))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(scoreColor(for: outfit.score)))
            }
            
            Text(outfit.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Text("Style:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(outfit.styleCategory)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.purple.opacity(0.2))
                    )
                
                Spacer()
            }
            
            // Strengths
            VStack(alignment: .leading, spacing: 4) {
                Text("Strengths:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                ForEach(outfit.strengths.prefix(2), id: \.self) { strength in
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption2)
                        
                        Text(strength)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isWinner ? Color.yellow.opacity(0.5) : Color.clear, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private func scoreColor(for score: Double) -> Color {
        switch score {
        case 9.0...10.0: return .green
        case 7.0..<9.0: return .blue
        case 5.0..<7.0: return .orange
        default: return .red
        }
    }
}
