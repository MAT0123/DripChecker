//
//  ColorCoordinationCard.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI

struct ColorCoordinationCard: View {
    let colorCoordination: ColorCoordination
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "paintpalette.fill")
                    .foregroundColor(.purple)
                    .font(.title3)
                
                Text("Color Coordination")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Rating
                HStack(spacing: 4) {
                    Text(String(format: "%.1f", colorCoordination.rating))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("/ 10")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Color Palette
            HStack(spacing: 8) {
                Text("Colors:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    ForEach(colorCoordination.primaryColors, id: \.self) { color in
                        Text(color)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.purple.opacity(0.2))
                            )
                    }
                }
                
                Spacer()
            }
            
            Text(colorCoordination.harmony)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}
