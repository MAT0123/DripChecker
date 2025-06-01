//
//  AIManager.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import Foundation
import UIKit
import OpenAI
import SwiftUI


class AIManager:ObservableObject{
    private var images: [UIImage] = [UIImage]()
    private let openAI = OpenAI(apiToken: Secrets.OPEN_AI_KEY ?? "")
    @Published var isAnalyzing = false
    @Published var showError:Bool = false
    @Published var errorMessage = ""
    @Published var analysis: AnalysisResult? = nil
    
    init(images: [UIImage]) {
        self.images = images
    }
    
    func showErrorAlert(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    func performOpenAIAnalysis(reviewType:ReviewType) async throws {
        do {
            // Convert images to base64
            let base64Images = images.compactMap { image in
                image.jpegData(compressionQuality: 0.8)
            }
            let imageURL: [URL?] = images.compactMap { image in
                let fileManager = FileManager()
                let tempDir = fileManager.temporaryDirectory
                let fileName = UUID().uuidString + ".jpg"
                let fileURL = tempDir.appendingPathComponent(fileName)
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    do {
                        try imageData.write(to: fileURL)
                        return fileURL
                    } catch {
                        print("Failed to write image to temp file: \(error)")
                        return nil
                    }
                }
                
                return nil
                
            }
            guard !base64Images.isEmpty else {
                throw AnalysisError.imageProcessingFailed
            }
            
            // Create messages based on review type
            let messages = createAnalysisMessages(data: base64Images, reviewType: reviewType)
            
            let chatQuery = ChatQuery(
                messages: messages, model: .gpt4_o,
                maxTokens: 2000
            )
            
            let result = try await openAI.chats(query: chatQuery)
            DispatchQueue.main.async {
                self.isAnalyzing = false
                if let content = result.choices.first?.message.content {
                    let analysis = AnalysisParser.parseAnalysis(from: content, reviewType: base64Images.count == 1 ? .single : .comparison)
                    self.analysis = analysis
                    let currentAnalysisCount = UserDefaults.standard.integer(forKey: "analysisCount")
                    
                    let currentComparisonAnalysisCount = UserDefaults.standard.integer(forKey: "comparisonCount")
                    do{
                        switch analysis {
                            
                        case .single(let single):
                            let historical = AnalysisHistoryItem.init(type: .single, date: .now, images: self.images, summary: single.overallImpression, overallScore: single.fashionScore.score)
                            SwiftDataManager.shared.save(historical)
                        case .comparison(let comparison):
                            let historical = AnalysisHistoryItem.init(type: .comparison, date: .now, images: self.images, summary: comparison.summary, overallScore: comparison.comparison.bestOutfit.score)
                            SwiftDataManager.shared.save(historical)
                            
                        case .error(let error):
                            break
                        }
                    }
                    catch{
                        print(error)
                    }
                    
                    
                } else {
                    self.showErrorAlert("No analysis received from AI")
                }
            }
            } catch {
            DispatchQueue.main.async {
                self.isAnalyzing = false
                self.showErrorAlert(error.localizedDescription)
            }
        }
    }
    
    func createAnalysisMessages(data: [Data] , reviewType:ReviewType) -> [ChatQuery.ChatCompletionMessageParam] {
        var messages: [ChatQuery.ChatCompletionMessageParam] = []
        
        if reviewType == .single {
            // Single outfit analysis prompt
            let systemPrompt = """
        You are a professional fashion stylist analyzing an outfit. Provide detailed, constructive feedback. 
                    
                    Return your analysis as a JSON object with the following structure:
                    {
                      "overall_impression": "1-2 sentence summary",
                      "style_analysis": {
                        "category": "e.g., casual, formal, streetwear, business casual",
                        "execution": "How well the style is executed",
                        "aesthetic": "Overall aesthetic description"
                      },
                      "color_coordination": {
                        "primary_colors": ["color1", "color2"],
                        "harmony": "How colors work together",
                        "rating": 8.5
                      },
                      "fit_and_silhouette": {
                        "assessment": "How the clothing fits",
                        "silhouette": "Description of overall silhouette",
                        "rating": 7.0
                      },
                      "styling_tips": [
                        "Specific improvement suggestion 1",
                        "Specific improvement suggestion 2",
                        "Specific improvement suggestion 3"
                      ],
                      "fashion_score": {
                        "score": 8.2,
                        "explanation": "Brief explanation of the score"
                      },
                      "strengths": ["What works well about this outfit"],
                      "areas_for_improvement": ["What could be enhanced"]
                    }
                    
                    Be encouraging but honest. Focus on actionable advice. Scores should be out of 10.
        """
            
            messages.append(.system(.init(content: systemPrompt)))
            
            // Add image message
            let imageContent: [ChatQuery.ChatCompletionMessageParam.UserMessageParam.Content] = [
                .string("Please analyze this outfit:"),
                .vision([.chatCompletionContentPartImageParam(.init(imageUrl: .init(url: data.first!, detail: .high)))])
            ]
            messages.append(.user(.init(content: imageContent[0])))
            messages.append(.user(.init(content: imageContent[1])))
            
            
        } else {
            // Comparison analysis prompt
            let systemPrompt = """
        You are a professional fashion stylist comparing multiple outfits. Analyze and compare the outfits in the provided images. Include:
        
        1. **Quick Overview** (Brief description of each outfit)
        2. **Style Comparison** (Which styles work better and why?)
        3. **Color & Coordination** (Compare color choices between outfits)
        4. **Best Outfit Recommendation** (Which one wins and why?)
        5. **Individual Strengths** (What's good about each outfit?)
        6. **Improvement Tips** (How to enhance the winning outfit further)
        
        Be specific about which outfit number you're referring to. Give a clear recommendation.
        """
            
            messages.append(.system(.init(content: systemPrompt)))
            
            // Add images with descriptions
            var imageContents: [ChatQuery.ChatCompletionMessageParam.UserMessageParam.Content] = [
                .string("Please compare these \(data.count) outfits:")
            ]
            
            for (index, base64Image) in data.enumerated() {
                imageContents.append(.string("Image number \(index)"))
                imageContents.append(.vision([.chatCompletionContentPartImageParam(.init(imageUrl: .init(url: data[index], detail: .high)))]))
                
            }
            imageContents.forEach { content in
                messages.append(.user(.init(content: content)))
                
            }
        }
        
        return messages
    }
}
