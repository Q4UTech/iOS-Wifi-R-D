//
//  NetworkSpeedMonitor.swift
//  WiFiProvider
//
//  Created by gautam  on 17/05/23.
//

import Foundation
import Network

class NetworkSpeedMonitor {
    private var uploadSpeed: Double = 0
    private var downloadSpeed: Double = 0
    
    private var uploadTask: URLSessionTask?
    private var downloadTask: URLSessionTask?
    
    private var timer: Timer?
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(measureNetworkSpeed), userInfo: nil, repeats: true)
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        
        uploadTask?.cancel()
        downloadTask?.cancel()
    }
    
    @objc private func measureNetworkSpeed() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                let connection = path.availableInterfaces.filter {_ in
                    path.isExpensive || !path.isExpensive
                }.first
                
                let url = URL(string: "https://www.google.com")! // Replace with the URL of your choice
                
                let uploadTask = URLSession.shared.uploadTask(with: URLRequest(url: url), from: Data()) { _, _, _ in }
                let downloadTask = URLSession.shared.dataTask(with: url) { _, _, _ in }
                
                let group = DispatchGroup()
                
                group.enter()
                uploadTask.resume()
                
                group.enter()
                downloadTask.resume()
                
                DispatchQueue.global(qos: .background).async {
                    group.wait()
                    
                    let uploadSpeed = Double(uploadTask.countOfBytesSent)
                    let downloadSpeed = Double(downloadTask.countOfBytesReceived)
                    
                    DispatchQueue.main.async {
                        self.uploadSpeed = uploadSpeed
                        self.downloadSpeed = downloadSpeed
                        
                        // Perform any further processing or display of speeds here
                        print("Upload Speed: \(uploadSpeed) bytes/sec")
                        print("Download Speed: \(downloadSpeed) bytes/sec")
                    }
                }
            }
        }
    }
}

// Usage:

