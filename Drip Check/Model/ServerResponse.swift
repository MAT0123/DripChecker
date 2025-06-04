//
//  ServerResponse.swift
//  Drip Check
//
//  Created by Matthew Tjoa on 2025-06-04.
//

import Foundation

struct FashionAnalysisRequest: Codable {
    let images: [String]
    let reviewType: String 
}

struct FashionAnalysisResponse: Codable {
    let success: Bool
    let analysis: String
    let reviewType: String
    let timestamp: String
}

struct FashionAnalysisErrorResponse: Codable {
    let error: String
}
