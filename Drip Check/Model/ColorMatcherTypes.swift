//
//  ColorMatcherTypes.swift
//  Drip Check
//
//  Created by Matthew Tjoa on 2025-06-03.
//

import Foundation

import Foundation

// MARK: - Welcome
struct ColorMatcher: Codable {
    let skinToneAnalysis: SkinToneAnalysis
    let recommendedColors: RecommendedColors
    let avoidColors: [String]
    let styleExamples: [StyleExample]
    let summary: String
    let score:Float
    
    enum CodingKeys: String, CodingKey {
        case skinToneAnalysis = "skin_tone_analysis"
        case recommendedColors = "recommended_colors"
        case avoidColors = "avoid_colors"
        case styleExamples = "style_examples"
        case summary
        case score
    }
}

// MARK: - RecommendedColors
struct RecommendedColors: Codable {
    let primaryPalette: [String]
    let seasonalSuggestion, rationale: String

    enum CodingKeys: String, CodingKey {
        case primaryPalette = "primary_palette"
        case seasonalSuggestion = "seasonal_suggestion"
        case rationale
    }
}

// MARK: - SkinToneAnalysis
struct SkinToneAnalysis: Codable {
    let toneCategory, hexColor, description: String

    enum CodingKeys: String, CodingKey {
        case toneCategory = "tone_category"
        case hexColor = "hex_color"
        case description
    }
}

// MARK: - StyleExample
struct StyleExample: Codable {
    let outfitType: String
    let colorCombination: [String]
    let comment: String

    enum CodingKeys: String, CodingKey {
        case outfitType = "outfit_type"
        case colorCombination = "color_combination"
        case comment
    }
}
