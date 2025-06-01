//
//  StyleDetailRow.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI

struct StyleDetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
