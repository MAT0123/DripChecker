//
//  ServerHealthChecker.swift
//  Drip Check
//
//  Created by Matthew Tjoa on 2025-06-01.
//

import Foundation

class ServerHealthChecker: ObservableObject {
    @Published var isServerHealthy = true
    @Published var isChecking = false
    
    func checkServerHealth() async {
        // Implementation to ping your server
        await MainActor.run {
            isChecking = true
        }
        
        // Check server health endpoint
        do {
            let url = URL(string: "https://drip-check-server-iyx6.vercel.app/api/health")!
            let (_, response) = try await URLSession.shared.data(from: url)
            print(response)
            
            await MainActor.run {
                isServerHealthy = (response as? HTTPURLResponse)?.statusCode == 200
                isChecking = false
            }
        } catch {
            await MainActor.run {
                isServerHealthy = false
                isChecking = false
            }
        }
    }
    init() {
        Task{
            await checkServerHealth()

        }
    }
}
