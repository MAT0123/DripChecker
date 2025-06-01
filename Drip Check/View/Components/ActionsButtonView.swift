//
//  ActionsButtonView.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI

struct ActionButtonsView: View {
    var reanalyzeAction: () -> Void
    let shareAction: () -> Void
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                reanalyzeAction()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise")
                    Text("Re-analyze")
                }
                .font(.subheadline)
                .foregroundColor(.purple)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.purple.opacity(0.5), lineWidth: 1)
                        .background(Color.white.opacity(0.8))
                )
            }
            
            Spacer()
            
            Button(action: {
               shareAction()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .pink]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(8)
            }
        }
        .padding(.top, 8)
    }
}
