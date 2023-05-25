//
//  TimeManager.swift
//  WiFiProvider
//
//  Created by gautam  on 25/05/23.
//

import Foundation


//class TimerManager {
//    static let shared = TimerManager()
//
//    private let startTimeKey = "StartTime"
//
//    private var startTime: Date?
//
//    private init() {
//        // Retrieve the stored start time from UserDefaults
//        if let storedTime = UserDefaults.standard.object(forKey: startTimeKey) as? Date {
//            startTime = storedTime
//        }
//    }
//
//    func startTimer() {
//        // Store the current time as the start time
//        startTime = Date()
//        UserDefaults.standard.set(startTime, forKey: startTimeKey)
//    }
//
//    func stopTimer() {
//        // Clear the stored start time
//        startTime = nil
//        UserDefaults.standard.removeObject(forKey: startTimeKey)
//    }
//
//    func getElapsedTime() -> TimeInterval {
//        if let startTime = startTime {
//            return Date().timeIntervalSince(startTime)
//        } else {
//            return 0
//        }
//    }
//}



protocol TimerManagerDelegate: AnyObject {
    func timerUpdated(time: TimeInterval)
}

class TimerManager {
    static let shared = TimerManager()
    
    private let startTimeKey = "StartTime"
    
    private var startTime: Date?
    private var timer: Timer?
    
    weak var delegate: TimerManagerDelegate?
    
    private init() {
        // Retrieve the stored start time from UserDefaults
        if let storedTime = UserDefaults.standard.object(forKey: startTimeKey) as? Date {
            startTime = storedTime
        }
    }
    
    func startTimer() {
        // Store the current time as the start time
        startTime = Date()
        UserDefaults.standard.set(startTime, forKey: startTimeKey)
        
        // Start the timer to update the elapsed time
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        // Clear the stored start time
        startTime = nil
        UserDefaults.standard.removeObject(forKey: startTimeKey)
        
        // Invalidate the timer
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTimer() {
        guard let startTime = startTime else {
            return
        }
        
        let elapsedTime = Date().timeIntervalSince(startTime)
        delegate?.timerUpdated(time: elapsedTime)
    }
    
    func getElapsedTime() -> TimeInterval {
        if let startTime = startTime {
            return Date().timeIntervalSince(startTime)
        } else {
            return 0
        }
    }
}
