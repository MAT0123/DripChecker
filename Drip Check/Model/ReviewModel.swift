//
//  ReviewModel.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import Foundation

enum ReviewType {
    case single
    case comparison
    case color_matcher
}

struct SingleOutfitAnalysis: Codable {
    let overallImpression: String
    let styleAnalysis: StyleAnalysis
    let colorCoordination: ColorCoordination
    let fitAndSilhouette: FitAndSilhouette
    let stylingTips: [String]
    let fashionScore: FashionScore
    let strengths: [String]
    let areasForImprovement: [String]
    
    enum CodingKeys: String, CodingKey {
        case overallImpression = "overall_impression"
        case styleAnalysis = "style_analysis"
        case colorCoordination = "color_coordination"
        case fitAndSilhouette = "fit_and_silhouette"
        case stylingTips = "styling_tips"
        case fashionScore = "fashion_score"
        case strengths
        case areasForImprovement = "areas_for_improvement"
    }
}

struct StyleAnalysis: Codable {
    let category: String
    let execution: String
    let aesthetic: String
}

struct ColorCoordination: Codable {
    let primaryColors: [String]
    let harmony: String
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case primaryColors = "primary_colors"
        case harmony
        case rating
    }
}

struct FitAndSilhouette: Codable {
    let assessment: String
    let silhouette: String
    let rating: Double
}

struct FashionScore: Codable {
    let score: Double
    let explanation: String
}

// MARK: - Comparison Analysis Models

struct ComparisonAnalysis: Codable {
    let outfits: [OutfitSummary]
    let comparison: ComparisonDetails
    let summary: String
}

struct OutfitSummary: Codable {
    let outfitNumber: Int
    let description: String
    let styleCategory: String
    let colorPalette: [String]
    let strengths: [String]
    let score: Double
    
    enum CodingKeys: String, CodingKey {
        case outfitNumber = "outfit_number"
        case description
        case styleCategory = "style_category"
        case colorPalette = "color_palette"
        case strengths
        case score
    }
}

struct ComparisonDetails: Codable {
    let styleAnalysis: String
    let colorCoordination: String
    let bestOutfit: BestOutfit
    let improvementTips: [String]
    
    enum CodingKeys: String, CodingKey {
        case styleAnalysis = "style_analysis"
        case colorCoordination = "color_coordination"
        case bestOutfit = "best_outfit"
        case improvementTips = "improvement_tips"
    }
}

struct BestOutfit: Codable {
    let number: Int
    let reason: String
    let score: Double
}

// MARK: - Unified Analysis Result

enum AnalysisResult {
    case single(SingleOutfitAnalysis)
    case comparison(ComparisonAnalysis)
    case color_matcher(ColorMatcher)

    case error(String)
    
    var isSingle: Bool {
        if case .single = self { return true }
        return false
    }
    
    var isComparison: Bool {
        if case .comparison = self { return true }
        return false
    }
    
    var isError: Bool {
        if case .error = self { return true }
        return false
    }
    
    var singleAnalysis: SingleOutfitAnalysis? {
        if case .single(let analysis) = self { return analysis }
        return nil
    }
    
    var comparisonAnalysis: ComparisonAnalysis? {
        if case .comparison(let analysis) = self { return analysis }
        return nil
    }
    
    var errorMessage: String? {
        if case .error(let message) = self { return message }
        return nil
    }
}

// MARK: - Analysis Parser

