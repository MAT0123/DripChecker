//
//  StyleVariable.swift
//  Drip Check
//
//  Created by Matthew Tjoa on 2025-06-04.
//

import Foundation

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
