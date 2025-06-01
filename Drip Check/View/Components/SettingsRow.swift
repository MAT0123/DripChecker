//
//  SettingsRow.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI

struct SettingsRow<Content: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let isDestructive: Bool
    let content: Content
    let action: () -> Void
    init(icon: String, title: String, subtitle: String, isDestructive: Bool = false, @ViewBuilder content: () -> Content , action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.isDestructive = isDestructive
        self.content = content()
        self.action = action
    }
    
    var body: some View {
        Button.init {
            action()
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(isDestructive ? .red : .purple)
                    .font(.system(size: 20))
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(isDestructive ? .red : .primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                content
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }

        
    }
}
