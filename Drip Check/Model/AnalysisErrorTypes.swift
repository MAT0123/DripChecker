//
//  AnalysisErrorTypes.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import Foundation

enum AnalysisError: Error, LocalizedError {
    case imageProcessingFailed
    case noAPIKey
    case analysisTimeout
    
    var errorDescription: String? {
        switch self {
        case .imageProcessingFailed:
            return "Failed to process images for analysis"
        case .noAPIKey:
            return "OpenAI API key not configured"
        case .analysisTimeout:
            return "Analysis request timed out"
        }
    }
}
