////
////  AIManager.swift
////  DripCheck
////
////  Created by Matthew Tjoa on 2025-05-31.
////
//
//import Foundation
//import UIKit
//import OpenAI
//import SwiftUI
//
//
//class AIManager:ObservableObject{
//    private var images: [UIImage] = [UIImage]()
//    private let openAI = OpenAI(apiToken: Secrets.OPEN_AI_KEY ?? "")
//    @Published var isAnalyzing = false
//    @Published var showError:Bool = false
//    @Published var errorMessage = ""
//    @Published var analysis: AnalysisResult? = nil
//    
//    init(images: [UIImage]) {
//        self.images = images
//    }
//    
//    func showErrorAlert(_ message: String) {
//        errorMessage = message
//        showError = true
//    }
//    
//    func performOpenAIAnalysis(reviewType:ReviewType) async throws {
//        do {
//            // Convert images to base64
//            let base64Images = images.compactMap { image in
//                image.jpegData(compressionQuality: 0.8)
//            }
//            let imageURL: [URL?] = images.compactMap { image in
//                let fileManager = FileManager()
//                let tempDir = fileManager.temporaryDirectory
//                let fileName = UUID().uuidString + ".jpg"
//                let fileURL = tempDir.appendingPathComponent(fileName)
//                if let imageData = image.jpegData(compressionQuality: 0.8) {
//                    do {
//                        try imageData.write(to: fileURL)
//                        return fileURL
//                    } catch {
//                        print("Failed to write image to temp file: \(error)")
//                        return nil
//                    }
//                }
//                
//                return nil
//                
//            }
//            guard !base64Images.isEmpty else {
//                throw AnalysisError.imageProcessingFailed
//            }
//            
//            // Create messages based on review type
//            let messages = createAnalysisMessages(data: base64Images, reviewType: reviewType)
//            
//            let chatQuery = ChatQuery(
//                messages: messages, model: .gpt4_o,
//                maxTokens: 2000
//            )
//            
//            let result = try await openAI.chats(query: chatQuery)
//            DispatchQueue.main.async {
//                self.isAnalyzing = false
//                if let content = result.choices.first?.message.content {
//                    let analysis = AnalysisParser.parseAnalysis(from: content, reviewType: base64Images.count == 1 ? .single : .comparison)
//                    self.analysis = analysis
//                    let currentAnalysisCount = UserDefaults.standard.integer(forKey: "analysisCount")
//                    
//                    let currentComparisonAnalysisCount = UserDefaults.standard.integer(forKey: "comparisonCount")
//                    do{
//                        switch analysis {
//                            
//                        case .single(let single):
//                            let historical = AnalysisHistoryItem.init(type: .single, date: .now, images: self.images, summary: single.overallImpression, overallScore: single.fashionScore.score)
//                            SwiftDataManager.shared.save(historical)
//                        case .comparison(let comparison):
//                            let historical = AnalysisHistoryItem.init(type: .comparison, date: .now, images: self.images, summary: comparison.summary, overallScore: comparison.comparison.bestOutfit.score)
//                            SwiftDataManager.shared.save(historical)
//                            
//                        case .error(let error):
//                            break
//                        }
//                    }
//                    catch{
//                        print(error)
//                    }
//                    
//                    
//                } else {
//                    self.showErrorAlert("No analysis received from AI")
//                }
//            }
//            } catch {
//            DispatchQueue.main.async {
//                self.isAnalyzing = false
//                self.showErrorAlert(error.localizedDescription)
//            }
//        }
//    }
//    
//    func createAnalysisMessages(data: [Data] , reviewType:ReviewType) -> [ChatQuery.ChatCompletionMessageParam] {
//        var messages: [ChatQuery.ChatCompletionMessageParam] = []
//        
//        if reviewType == .single {
//            // Single outfit analysis prompt
//            let systemPrompt = """
//        You are a professional fashion stylist analyzing an outfit. Provide detailed, constructive feedback. 
//                    
//                    Return your analysis as a JSON object with the following structure:
//                    {
//                      "overall_impression": "1-2 sentence summary",
//                      "style_analysis": {
//                        "category": "e.g., casual, formal, streetwear, business casual",
//                        "execution": "How well the style is executed",
//                        "aesthetic": "Overall aesthetic description"
//                      },
//                      "color_coordination": {
//                        "primary_colors": ["color1", "color2"],
//                        "harmony": "How colors work together",
//                        "rating": 8.5
//                      },
//                      "fit_and_silhouette": {
//                        "assessment": "How the clothing fits",
//                        "silhouette": "Description of overall silhouette",
//                        "rating": 7.0
//                      },
//                      "styling_tips": [
//                        "Specific improvement suggestion 1",
//                        "Specific improvement suggestion 2",
//                        "Specific improvement suggestion 3"
//                      ],
//                      "fashion_score": {
//                        "score": 8.2,
//                        "explanation": "Brief explanation of the score"
//                      },
//                      "strengths": ["What works well about this outfit"],
//                      "areas_for_improvement": ["What could be enhanced"]
//                    }
//                    
//                    Be encouraging but honest. Focus on actionable advice. Scores should be out of 10.
//        """
//            
//            messages.append(.system(.init(content: systemPrompt)))
//            
//            // Add image message
//            let imageContent: [ChatQuery.ChatCompletionMessageParam.UserMessageParam.Content] = [
//                .string("Please analyze this outfit:"),
//                .vision([.chatCompletionContentPartImageParam(.init(imageUrl: .init(url: data.first!, detail: .high)))])
//            ]
//            messages.append(.user(.init(content: imageContent[0])))
//            messages.append(.user(.init(content: imageContent[1])))
//            
//            
//        } else {
//            // Comparison analysis prompt
//            let systemPrompt = """
//        You are a professional fashion stylist comparing multiple outfits. Analyze and compare the outfits in the provided images. Include:
//        
//        1. **Quick Overview** (Brief description of each outfit)
//        2. **Style Comparison** (Which styles work better and why?)
//        3. **Color & Coordination** (Compare color choices between outfits)
//        4. **Best Outfit Recommendation** (Which one wins and why?)
//        5. **Individual Strengths** (What's good about each outfit?)
//        6. **Improvement Tips** (How to enhance the winning outfit further)
//        
//        Be specific about which outfit number you're referring to. Give a clear recommendation.
//        """
//            
//            messages.append(.system(.init(content: systemPrompt)))
//            
//            // Add images with descriptions
//            var imageContents: [ChatQuery.ChatCompletionMessageParam.UserMessageParam.Content] = [
//                .string("Please compare these \(data.count) outfits:")
//            ]
//            
//            for (index, base64Image) in data.enumerated() {
//                imageContents.append(.string("Image number \(index)"))
//                imageContents.append(.vision([.chatCompletionContentPartImageParam(.init(imageUrl: .init(url: data[index], detail: .high)))]))
//                
//            }
//            imageContents.forEach { content in
//                messages.append(.user(.init(content: content)))
//                
//            }
//        }
//        
//        return messages
//    }
//}
//
//  AIManager.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-06-01.
//

import Foundation
import UIKit
import SwiftUI

// MARK: - Server Request/Response Models

struct FashionAnalysisRequest: Codable {
    let images: [String]  // Base64 encoded images
    let reviewType: String // "single" or "comparison"
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

// MARK: - AI Manager Class

@MainActor
class AIManager: ObservableObject {
    
    // MARK: - Properties
    
    private var images: [UIImage] = []
    
    // Server configuration
    private let serverBaseURL: String = {
        return "https://drip-check-server-iyx6.vercel.app/api"
    }()
    
    // Published properties for UI binding
    @Published var isAnalyzing = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var analysis: AnalysisResult? = nil
    
    // MARK: - Initialization
    
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
    
    // MARK: - Private Helper Methods
    
    private func convertImagesToBase64() async throws -> [String] {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let base64Images = images.compactMap { image -> String? in
                        // Compress image for upload
                        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
                            return nil
                        }
                        return imageData.base64EncodedString()
                    }
                    
                    guard !base64Images.isEmpty else {
                        throw AnalysisError.imageProcessingFailed
                    }
                    
                    continuation.resume(returning: base64Images)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
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
        request.timeoutInterval = 120.0 // 2 minutes timeout for AI processing
        
        // Create request body
        let requestBody = FashionAnalysisRequest(
            images: images,
            reviewType: reviewType == .single ? "single" : "comparison"
        )
        
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

// MARK: - Mock Methods for Testing

extension AIManager {
    
    // For testing without server
    func performMockAnalysis(reviewType: ReviewType) async {
        isAnalyzing = true
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
        
        let mockResult: AnalysisResult = reviewType == .single
            ? .single(createMockSingleAnalysis())
            : .comparison(createMockComparisonAnalysis())
        
        analysis = mockResult
        saveAnalysisLocally(mockResult)
        isAnalyzing = false
    }
    
    private func createMockSingleAnalysis() -> SingleOutfitAnalysis {
        return SingleOutfitAnalysis(
            overallImpression: "This outfit demonstrates excellent style awareness with great attention to color coordination and fit.",
            styleAnalysis: StyleAnalysis(
                category: "Smart Casual",
                execution: "Very well executed with attention to detail",
                aesthetic: "Modern and sophisticated with a relaxed vibe"
            ),
            colorCoordination: ColorCoordination(
                primaryColors: ["Navy Blue", "White", "Khaki"],
                harmony: "The color palette creates a cohesive and polished look",
                rating: 8.7
            ),
            fitAndSilhouette: FitAndSilhouette(
                assessment: "Excellent fit that flatters your body type",
                silhouette: "Well-balanced proportions with a clean, tailored appearance",
                rating: 8.5
            ),
            stylingTips: [
                "Consider adding a watch or subtle jewelry for extra sophistication",
                "This combination would work well with different shoe styles",
                "Try rolling up sleeves slightly for a more casual look when appropriate"
            ],
            fashionScore: FashionScore(
                score: 8.6,
                explanation: "Strong overall execution with excellent fundamentals"
            ),
            strengths: [
                "Excellent color coordination",
                "Perfect fit and proportions",
                "Versatile and occasion-appropriate",
                "Clean, polished appearance"
            ],
            areasForImprovement: [
                "Could benefit from a subtle accessory",
                "Consider experimenting with textures for added interest"
            ]
        )
    }
    
    private func createMockComparisonAnalysis() -> ComparisonAnalysis {
        return ComparisonAnalysis(
            outfits: [
                OutfitSummary(
                    outfitNumber: 1,
                    description: "Professional business casual look with excellent structure",
                    styleCategory: "Business Casual",
                    colorPalette: ["Navy", "White", "Brown"],
                    strengths: ["Professional appearance", "Great fit", "Versatile"],
                    score: 8.8
                ),
                OutfitSummary(
                    outfitNumber: 2,
                    description: "Relaxed casual outfit perfect for weekend activities",
                    styleCategory: "Weekend Casual",
                    colorPalette: ["Denim", "Gray", "White"],
                    strengths: ["Comfortable", "On-trend", "Relaxed vibe"],
                    score: 7.9
                )
            ],
            comparison: ComparisonDetails(
                styleAnalysis: "Outfit 1 offers superior versatility and professional polish, while Outfit 2 excels in comfort and casual appeal.",
                colorCoordination: "Both outfits use harmonious color schemes, with Outfit 1 showing more sophisticated color choices.",
                bestOutfit: BestOutfit(
                    number: 1,
                    reason: "More versatile and polished, suitable for multiple occasions from work to social events",
                    score: 8.8
                ),
                improvementTips: [
                    "Add a quality leather belt to enhance the professional look",
                    "Consider swapping shoes to adjust formality level as needed"
                ]
            ),
            summary: "Outfit 1 is the clear winner for its versatility and professional polish, perfect for business casual environments."
        )
    }
}

// MARK: - Network Monitoring (Optional)

import Network

extension AIManager {
    
    // Monitor network connectivity
    func startNetworkMonitoring() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status != .satisfied {
                    self?.showErrorAlert("No internet connection. Please check your network.")
                }
            }
        }
        
        monitor.start(queue: queue)
    }
}
