
//
//  AIManager.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-06-01.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
class AIManager: ObservableObject {
    
    // MARK: - Properties
    
    private var images: [UIImage] = []
    
    // Server configuration
    private let serverBaseURL: String = {
        return "https://dripcheckapi.matthewautjoa.tech/api"
    }()
    
    // Published properties for UI binding
    @Published var isAnalyzing = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var analysis: AnalysisResult? = nil
        
    init(images: [UIImage]) {
        self.images = images
    }
    
    // MARK: - Public Methods
    
    func performOpenAIAnalysis(reviewType: ReviewType) async throws {
        // Reset state
        isAnalyzing = true
        showError = false
        errorMessage = ""
        analysis = nil
        
        do {
            // Step 1: Convert images to base64
            let base64Images = try await convertImagesToBase64()
            
            // Step 2: Send request to server
            let serverResponse = try await sendAnalysisRequest(
                images: base64Images,
                reviewType: reviewType
            )
            
            // Step 3: Parse the analysis from server response
            let analysisResult = parseServerResponse(
                serverResponse,
                reviewType: reviewType
            )
            
            // Step 4: Update UI and save locally
            analysis = analysisResult
            saveAnalysisLocally(analysisResult)
            
        } catch {
            // Handle any errors
            handleError(error)
            throw error
        }
        
        isAnalyzing = false
    }
    
    func showErrorAlert(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    
    private func convertImagesToBase64() async throws -> [String] {
        return try await ImageHelper.convertImagesToBase64(images: images)
    }
    
    private func sendAnalysisRequest(images: [String], reviewType: ReviewType) async throws -> FashionAnalysisResponse {
        // Prepare the URL
        guard let url = URL(string: "\(serverBaseURL)/analyze-fashion") else {
            throw AnalysisError.noAPIKey // Reusing for invalid URL
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 60
        
        // Create request body
        let requestBody = FashionAnalysisRequest(
            images: images,
            reviewType: reviewType == .single ? "single" : (reviewType == .color_matcher ? "color" : "comparison")
        )
        print(requestBody)
        // Encode request body to JSON
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
        } catch {
            throw AnalysisError.imageProcessingFailed
        }
        
        // Send the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AnalysisError.analysisTimeout
        }
        
        // Handle different status codes
        switch httpResponse.statusCode {
        case 200:
            // Success - decode the response
            do {
                let analysisResponse = try JSONDecoder().decode(FashionAnalysisResponse.self, from: data)
                return analysisResponse
            } catch {
                print("JSON decode error: \(error)")
                throw AnalysisError.imageProcessingFailed
            }
            
        case 400:
            // Bad request
            if let errorResponse = try? JSONDecoder().decode(FashionAnalysisErrorResponse.self, from: data) {
                throw NSError(domain: "FashionAnalysis", code: 400, userInfo: [
                    NSLocalizedDescriptionKey: errorResponse.error
                ])
            }
            throw AnalysisError.imageProcessingFailed
            
        case 429:
            // Rate limit exceeded
            throw NSError(domain: "FashionAnalysis", code: 429, userInfo: [
                NSLocalizedDescriptionKey: "Too many requests. Please try again in a moment."
            ])
            
        case 500:
            // Server error
            if let errorResponse = try? JSONDecoder().decode(FashionAnalysisErrorResponse.self, from: data) {
                throw NSError(domain: "FashionAnalysis", code: 500, userInfo: [
                    NSLocalizedDescriptionKey: errorResponse.error
                ])
            }
            throw AnalysisError.analysisTimeout
            
        default:
            throw AnalysisError.analysisTimeout
        }
    }
    
    private func parseServerResponse(_ response: FashionAnalysisResponse, reviewType: ReviewType) -> AnalysisResult {
        // Parse the analysis string from server into AnalysisResult
        return AnalysisParser.parseAnalysis(from: response.analysis, reviewType: reviewType)
    }
    
    private func saveAnalysisLocally(_ analysisResult: AnalysisResult) {
        do {
            switch analysisResult {
            case .single(let singleAnalysis):
                let historyItem = AnalysisHistoryItem(
                    type: .single,
                    date: Date.now,
                    images: images,
                    summary: singleAnalysis.overallImpression,
                    overallScore: singleAnalysis.fashionScore.score
                )
                SwiftDataManager.shared.save(historyItem)
                
            case .comparison(let comparisonAnalysis):
                let historyItem = AnalysisHistoryItem(
                    type: .comparison,
                    date: Date.now,
                    images: images,
                    summary: comparisonAnalysis.summary,
                    overallScore: comparisonAnalysis.comparison.bestOutfit.score
                )
                SwiftDataManager.shared.save(historyItem)
            
            case .color_matcher(let colorMatcher):
                SwiftDataManager.shared.save(AnalysisHistoryItem(type: .color_matcher, date: .now, images: images, summary: colorMatcher.summary, overallScore: Double(colorMatcher.score)))
            case .error(_):
                // Don't save error results
                break
            
            }
        } catch {
            print("Error saving analysis locally: \(error)")
        }
    }
    
    private func handleError(_ error: Error) {
        if let nsError = error as NSError? {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet:
                errorMessage = "No internet connection. Please check your network."
            case NSURLErrorTimedOut:
                errorMessage = "Request timed out. Please try again."
            case 400:
                errorMessage = nsError.localizedDescription
            case 429:
                errorMessage = "Too many requests. Please wait a moment and try again."
            case 500:
                errorMessage = nsError.localizedDescription
            default:
                errorMessage = "Analysis failed. Please try again."
            }
        } else if let analysisError = error as? AnalysisError {
            errorMessage = analysisError.localizedDescription
        } else {
            errorMessage = "An unexpected error occurred."
        }
        
        showError = true
    }
}

// MARK: - Additional Helper Methods

extension AIManager {
    
    // Check if server is reachable
    func checkServerHealth() async -> Bool {
        guard let url = URL(string: "\(serverBaseURL)/health") else {
            return false
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               json["status"] as? String == "OK" {
                return true
            }
        } catch {
            print("Health check failed: \(error)")
        }
        
        return false
    }
    
    // Retry analysis with exponential backoff
    func performAnalysisWithRetry(reviewType: ReviewType, maxRetries: Int = 3) async throws {
        var lastError: Error?
        
        for attempt in 1...maxRetries {
            do {
                try await performOpenAIAnalysis(reviewType: reviewType)
                return // Success - exit retry loop
            } catch {
                lastError = error
                
                // Don't retry on certain errors
                if let nsError = error as NSError?, nsError.code == 400 {
                    throw error // Bad request - don't retry
                }
                
                if attempt < maxRetries {
                    // Exponential backoff: 2s, 4s, 8s
                    let delay = Double(attempt * 2)
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            }
        }
        
        // All retries failed
        throw lastError ?? AnalysisError.analysisTimeout
    }
    
   
}



