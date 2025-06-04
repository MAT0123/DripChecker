//
//  ImageHelper.swift
//  Drip Check
//
//  Created by Matthew Tjoa on 2025-06-04.
//

import Foundation
import UIKit
class ImageHelper {
    static func convertImagesToBase64(images:[UIImage]) async throws -> [String] {
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
}
