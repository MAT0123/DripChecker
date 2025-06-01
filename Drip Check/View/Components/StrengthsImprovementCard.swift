//
//  StrengthsImprovementCard.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI

struct StrengthsImprovementCard: View {
    let strengths: [String]
    let improvements: [String]
    
    var body: some View {
        VStack(spacing: 16) {
            // Strengths
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                    
                    Text("Strengths")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                ForEach(strengths, id: \.self) { strength in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                        
                        Text(strength)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Divider()
            
            // Areas for Improvement
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                    
                    Text("Areas for Improvement")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                ForEach(improvements, id: \.self) { improvement in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "arrow.up.circle")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text(improvement)
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
