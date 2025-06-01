//
//  StyleAnalysisCard.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI

struct StyleAnalysisCard: View {
    let styleAnalysis: StyleAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: styleAnalysis.categoryIcon)
                    .foregroundColor(.purple)
                    .font(.title3)
                
                Text("Style Analysis")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                StyleDetailRow(label: "Category", value: styleAnalysis.category)
                StyleDetailRow(label: "Execution", value: styleAnalysis.execution)
                StyleDetailRow(label: "Aesthetic", value: styleAnalysis.aesthetic)
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
