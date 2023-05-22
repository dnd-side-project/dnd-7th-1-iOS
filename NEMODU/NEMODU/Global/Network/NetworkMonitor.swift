//
//  NetworkMonitor.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/22.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private(set) var isConnected: Bool = false
    
    private init(){
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = path.status == .satisfied
        }
    }
    
    public func stopMonitoring(){
        monitor.cancel()
    }
}
