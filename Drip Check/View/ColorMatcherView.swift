//
//  ColorMatcherView.swift
//  Drip Check
//
//  Created by Assistant on 2025-06-03.
//

import SwiftUI

struct ColorMatcherView: View {
    let colorMatcher: ColorMatcher
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with Score
                HeaderSection(score: Float(colorMatcher.score))
                
                // Skin Tone Analysis
                SkinToneSection(skinToneAnalysis: colorMatcher.skinToneAnalysis)
                
                // Recommended Colors
                RecommendedColorsSection(recommendedColors: colorMatcher.recommendedColors)
                
                // Colors to Avoid
                AvoidColorsSection(avoidColors: colorMatcher.avoidColors)
                
                // Style Examples
                StyleExamplesSection(styleExamples: colorMatcher.styleExamples)
                
                // Summary
                SummarySection(summary: colorMatcher.summary)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Color Analysis")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Header Section
struct HeaderSection: View {
    let score: Float
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Your Color Match Score")
                .font(.headline)
                .foregroundColor(.secondary)
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: CGFloat(score))
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                
                Text("\(score * 100)%")
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Skin Tone Section
struct SkinToneSection: View {
    let skinToneAnalysis: SkinToneAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Skin Tone Analysis", icon: "person.circle.fill")
            
            HStack(spacing: 16) {
                // Color Circle
                Circle()
                    .fill(Color(hex: skinToneAnalysis.hexColor) ?? .gray)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(skinToneAnalysis.toneCategory)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(skinToneAnalysis.hexColor.uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Text(skinToneAnalysis.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(nil)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Recommended Colors Section
struct RecommendedColorsSection: View {
    let recommendedColors: RecommendedColors
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Recommended Colors", icon: "paintpalette.fill")
            
            // Primary Palette
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                ForEach(recommendedColors.primaryPalette, id: \.self) { colorName in
                    ColorChip(colorName: colorName, isRecommended: true)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Seasonal Suggestion")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(recommendedColors.seasonalSuggestion)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("Why these colors work:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(.top, 8)
                
                Text(recommendedColors.rationale)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Avoid Colors Section
struct AvoidColorsSection: View {
    let avoidColors: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Colors to Avoid", icon: "xmark.circle.fill")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                ForEach(avoidColors, id: \.self) { colorName in
                    ColorChip(colorName: colorName, isRecommended: false)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Style Examples Section
struct StyleExamplesSection: View {
    let styleExamples: [StyleExample]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Style Examples", icon: "tshirt.fill")
            
            ForEach(Array(styleExamples.enumerated()), id: \.offset) { index, example in
                StyleExampleCard(styleExample: example)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Summary Section
struct SummarySection: View {
    let summary: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Summary", icon: "doc.text.fill")
            
            Text(summary)
                .font(.body)
                .lineLimit(nil)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Helper Views

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
}

struct ColorChip: View {
    let colorName: String
    let isRecommended: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(Color(hex: colorName) ?? .secondary)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(
                            isRecommended ? Color.green : Color.red,
                            lineWidth: isRecommended ? 0 : 2
                        )
                )
                .overlay(
                    Group {
                        if !isRecommended {
                            Image(systemName: "xmark")
                                .font(.caption)
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                        }
                    }
                )
            
            Text(colorName.capitalized)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 30)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isRecommended ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        )
    }
}

struct StyleExampleCard: View {
    let styleExample: StyleExample
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(styleExample.outfitType)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            HStack {
                Text("Colors:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    ForEach(styleExample.colorCombination, id: \.self) { color in
                        Circle()
                            .fill(Color(color) ?? Color.gray)
                            .frame(width: 20, height: 20)
                    }
                }
                
                Spacer()
            }
            
            Text(styleExample.comment)
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Color Extension
extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview
struct ColorMatcherView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ColorMatcherView(colorMatcher: sampleColorMatcher)
        }
    }
    
    static let sampleColorMatcher = ColorMatcher(
        skinToneAnalysis: SkinToneAnalysis(
            toneCategory: "Warm Medium",
            hexColor: "#C68642",
            description: "You have a warm undertone with medium depth. Your skin has golden and peachy undertones that complement earth tones and warm colors beautifully."
        ),
        recommendedColors: RecommendedColors(
            primaryPalette: ["coral", "olive", "cream", "rust", "gold", "chocolate", "sage", "peach"],
            seasonalSuggestion: "Autumn",
            rationale: "Your warm undertones are beautifully complemented by rich, earthy colors that echo the golden tones in your skin."
        ),
        avoidColors: ["icy blue", "stark white", "silver", "bright pink"],
        styleExamples: [
            StyleExample(
                outfitType: "Business Casual",
                colorCombination: ["olive", "cream", "gold"],
                comment: "Perfect for office wear - sophisticated and professional"
            ),
            StyleExample(
                outfitType: "Weekend Casual",
                colorCombination: ["rust", "chocolate", "sage"],
                comment: "Earthy and relaxed while still looking put-together"
            )
        ],
        summary: "Your warm medium skin tone is perfectly suited for rich, earthy colors. Focus on autumn tones and avoid cool, icy shades for the most flattering look.",
        score: 0.87
    )
}
