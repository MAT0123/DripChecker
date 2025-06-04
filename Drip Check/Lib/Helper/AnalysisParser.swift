//
//  AnalysisParser.swift
//  Drip Check
//
//  Created by Matthew Tjoa on 2025-06-04.
//

import Foundation

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
            case .color_matcher:
                if let jsonString = String(data: data, encoding: .utf8) {
                       print("Raw JSON from server:\n\(jsonString)")

                       // Check if it's an empty object (i.e. {})
                       if jsonString.trimmingCharacters(in: .whitespacesAndNewlines) == "{}" {
                           return .error("Analysis failed: Server returned empty results.")
                       }
                   }
                let analysis = try JSONDecoder().decode(ColorMatcher.self, from: data)
                return .color_matcher(analysis)
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


