//
//  NetworkManager.swift
//  Drip Check
//
//  Created by Matthew Tjoa on 2025-06-04.
//

import Foundation
import Network

class NetworkManager:ObservableObject {
    @Published var internetStatus:NWPath.Status = .unsatisfied
    private var monitor: NWPathMonitor?

    init() {
        startNetworkMonitoring()
    }
    func startNetworkMonitoring() {
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status != .satisfied {
                    self?.internetStatus = path.status
                }
            }
        }
        
        monitor?.start(queue: queue)
    }
    func stopMonitoring() {
            monitor?.cancel()
            monitor = nil
        }

        deinit {
            stopMonitoring()
        }
}
