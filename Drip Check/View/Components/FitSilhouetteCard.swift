//
//  FitSilhouetteCard.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI

struct FitSilhouetteCard: View {
    let fitAndSilhouette: FitAndSilhouette
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "figure.walk")
                    .foregroundColor(.purple)
                    .font(.title3)
                
                Text("Fit & Silhouette")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Rating
                HStack(spacing: 4) {
                    Text(String(format: "%.1f", fitAndSilhouette.rating))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("/ 10")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                StyleDetailRow(label: "Assessment", value: fitAndSilhouette.assessment)
                StyleDetailRow(label: "Silhouette", value: fitAndSilhouette.silhouette)
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
