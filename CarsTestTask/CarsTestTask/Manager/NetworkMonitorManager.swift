//
//  NetworkMonitorManager.swift
//  CarsTestTask
//
//  Created by Vitaliy Halai on 26.12.23.
//

import Foundation
import Network

final class NetworkMonitorManager {
    
    //MARK: Singleton
    static let shared = NetworkMonitorManager()
    
    //MARK: Private properties
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    //MARK: Public properties
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    //MARK: Connection types
    enum ConnectionType {
        case wifi
        case cellular
        case wired
        case unknown
    }
    
    //MARK: Constructor with monitor
    private init() {
        monitor = NWPathMonitor()
    }
    
    
    //MARK: Public funcs
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.getConnectionType(path)
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    //MARK: Private funcs
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular){
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .wired
        } else {
            connectionType = .unknown
        }
        
    }
}
