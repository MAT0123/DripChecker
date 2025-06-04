
import Foundation
import SwiftData
import UIKit

@Model
class AnalysisHistoryItem {
    @Attribute(.unique) var id: UUID
    var type: AnalysisType
    var date: Date
    var imagesData: [Data]
    var summary: String
    var overallScore: Double?

    @Transient
    var images: [UIImage] {
        get {
            imagesData.compactMap { UIImage(data: $0) }
        }
        set {
            imagesData = newValue.compactMap { $0.jpegData(compressionQuality: 0.8) }
        }
    }

    init(id: UUID = UUID(), type: AnalysisType, date: Date, images: [UIImage], summary: String, overallScore: Double?) {
        self.id = id
        self.type = type
        self.date = date
        self.imagesData = images.compactMap { $0.jpegData(compressionQuality: 0.8) }
        self.summary = summary
        self.overallScore = overallScore
    }
}

enum AnalysisType: String, Codable, CaseIterable {
    case single = "single"
    case comparison = "comparison"
    case color_matcher = "color_mathcer"
    var displayName: String {
        switch self {
        case .single: return "Single Outfit"
        case .comparison: return "Outfit Comparison"
        case .color_matcher : return "Color Matching"
        }
    }
}
