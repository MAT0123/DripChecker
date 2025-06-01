//
//  FashionCardScore.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI

struct FashionScoreCard: View {
    let score: FashionScore
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Fashion Score")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(score.scoreEmoji)
                    .font(.title2)
            }
            
            // Circular Score Display
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: score.score / 10.0)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: scoreGradientColors(for: score.score)),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 2) {
                    Text(String(format: "%.1f", score.score))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("/ 10")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(score.explanation)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private func scoreGradientColors(for score: Double) -> [Color] {
        switch score {
        case 9.0...10.0: return [.green, .mint]
        case 7.0..<9.0: return [.blue, .cyan]
        case 5.0..<7.0: return [.orange, .yellow]
        default: return [.red, .pink]
        }
    }
}
