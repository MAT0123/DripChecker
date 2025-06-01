//
//  AnalysisHistoryCard.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI

struct AnalysisHistoryCard: View {
    let item: AnalysisHistoryItem
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with date and type
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.type.displayName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(item.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Score badge
                if let score = item.overallScore {
                    Text(String(format: "%.1f", score))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle().fill(scoreColor(for: score))
                        )
                }
                
                // Delete button
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red.opacity(0.7))
                        .font(.system(size: 16))
                }
            }
            
            // Images preview
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(item.images.enumerated()), id: \.offset) { index, image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
            
            // Summary preview
            if !item.summary.isEmpty {
                Text(item.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            // View details button
//            Button(action: {
//                // TODO: Navigate to detailed view
//            }) {
//                HStack {
//                    Text("View Details")
//                        .font(.subheadline)
//                        .fontWeight(.medium)
//                    
//                    Image(systemName: "chevron.right")
//                        .font(.caption)
//                }
//                .foregroundColor(.purple)
//            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .transition(.move(edge: .leading))
        .animation(.easeIn)
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
