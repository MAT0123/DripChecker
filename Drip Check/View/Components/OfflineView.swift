//
//  OfflineView.swift
//  Drip Check
//
//  Created by Matthew Tjoa on 2025-06-01.
//

import SwiftUI

struct ServerOfflineView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cloud.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Service Temporarily Unavailable")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Our fashion analysis service is currently offline. Please try again later.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button("Try Again") {
                // Retry logic
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
