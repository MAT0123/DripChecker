//
//  SwiftDataManager.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import Foundation

import SwiftData

@MainActor
class SwiftDataManager {
    static let shared = SwiftDataManager()
    
    private var context: ModelContext {
        modelContainer.mainContext
    }

    private let modelContainer: ModelContainer

    private init() {
        let schema = Schema([AnalysisHistoryItem.self])
        self.modelContainer = try! ModelContainer(for: schema, configurations: [])
    }

    // Save a new item
    func save(_ item: AnalysisHistoryItem) {
        context.insert(item)
        do {
                try context.save()
                print("✅ Saved: \(item.summary) (\(item.id))")
            } catch {
                print("❌ Failed to save: \(error)")
            }
    }

    // Fetch items by type
    func get(type: AnalysisType) -> [AnalysisHistoryItem] {
        let descriptor = FetchDescriptor<AnalysisHistoryItem>(
            predicate: #Predicate { $0.type == type },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    // Delete all items of a specific type
    func deleteAll(of type: AnalysisType) {
        let items = get(type: type)
        for item in items {
            context.delete(item)
        }
        try? context.save()
        
    }
    
    func delete(id: UUID) {
        let descriptor = FetchDescriptor<AnalysisHistoryItem>(
            predicate: #Predicate { $0.id == id }
        )

        if let items = try? context.fetch(descriptor), let target = items.first {
            context.delete(target)
            try? context.save()
        }
    }
    
    // Delete all items regardless of type
    func deleteAll() {
        let fetchRequest = FetchDescriptor<AnalysisHistoryItem>()
        if let allItems = try? context.fetch(fetchRequest) {
            for item in allItems {
                context.delete(item)
            }
            try? context.save()
        }
    }

    // Count items by type
    func count(type: AnalysisType) -> Int {
        return get(type: type).count
    }
}
