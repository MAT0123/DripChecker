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

struct AnalysisParser {
    static func parseAnalysis(from jsonString: String, reviewType: ReviewType) -> AnalysisResult {
        
        let cleanedJSON = jsonString
                        .replacingOccurrences(of: "```json", with: "")
                        .replacingOccurrences(of: "```", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let data = cleanedJSON.data(using: .utf8) else {
            return .error("Failed to convert response to data")
        }
        
        do {
            switch reviewType {
            case .single:
                let analysis = try JSONDecoder().decode(SingleOutfitAnalysis.self, from: data)
                return .single(analysis)
            case .comparison:
                let analysis = try JSONDecoder().decode(ComparisonAnalysis.self, from: data)
                return .comparison(analysis)
            }
        } catch {
            // Try to extract meaningful error info
            if let jsonError = error as? DecodingError {
                let errorMessage = parseDecodingError(jsonError)
                return .error("Failed to parse analysis: \(errorMessage)")
            } else {
                return .error("Failed to parse analysis: \(error.localizedDescription)")
            }
        }
    }
    
    private static func parseDecodingError(_ error: DecodingError) -> String {
        switch error {
        case .keyNotFound(let key, _):
            return "Missing key: \(key.stringValue)"
        case .typeMismatch(let type, let context):
            return "Type mismatch for \(type) at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
        case .valueNotFound(let type, let context):
            return "Value not found for \(type) at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
        case .dataCorrupted(let context):
            return "Data corrupted at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
        @unknown default:
            return "Unknown decoding error"
        }
    }
}

// MARK: - Extensions for UI

extension StyleAnalysis {
    var categoryIcon: String {
        switch category.lowercased() {
        case "casual":
            return "tshirt"
        case "formal":
            return "suit.fill"
        case "business casual":
            return "briefcase"
        case "streetwear":
            return "figure.walk"
        case "athletic", "sporty":
            return "figure.run"
        case "bohemian", "boho":
            return "leaf"
        default:
            return "shirt"
        }
    }
    
    var categoryColor: String {
        switch category.lowercased() {
        case "casual":
            return "blue"
        case "formal":
            return "black"
        case "business casual":
            return "gray"
        case "streetwear":
            return "orange"
        case "athletic", "sporty":
            return "green"
        case "bohemian", "boho":
            return "purple"
        default:
            return "blue"
        }
    }
}

extension FashionScore {
    var scoreColor: String {
        switch score {
        case 9.0...10.0:
            return "green"
        case 7.0..<9.0:
            return "blue"
        case 5.0..<7.0:
            return "orange"
        default:
            return "red"
        }
    }
    
    var scoreEmoji: String {
        switch score {
        case 9.0...10.0:
            return "🔥"
        case 7.0..<9.0:
            return "👌"
        case 5.0..<7.0:
            return "👍"
        default:
            return "💡"
        }
    }
}

extension OutfitSummary {
    var scoreColor: String {
        switch score {
        case 9.0...10.0:
            return "green"
        case 7.0..<9.0:
            return "blue"
        case 5.0..<7.0:
            return "orange"
        default:
            return "red"
        }
    }
}
