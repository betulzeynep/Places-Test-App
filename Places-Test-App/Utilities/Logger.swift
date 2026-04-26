//
//  Logger.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation
import os.log

// MARK: - Log Level
enum LogLevel: String {
    case debug = "🔍 DEBUG"
    case info = "ℹ️ INFO"
    case warning = "⚠️ WARNING"
    case error = "❌ ERROR"
    case success = "✅ SUCCESS"
}

// MARK: - Logger
final class Logger {
    
    // MARK: - Properties
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.places.app"
    
    // MARK: - OSLog Categories
    private static let networkLogger = OSLog(subsystem: subsystem, category: "Network")
    private static let uiLogger = OSLog(subsystem: subsystem, category: "UI")
    private static let dataLogger = OSLog(subsystem: subsystem, category: "Data")
    private static let generalLogger = OSLog(subsystem: subsystem, category: "General")
    
    // MARK: - Public Methods
    
    /// Logs network-related messages
    static func network(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: level, logger: networkLogger, file: file, function: function, line: line)
    }
    
    /// Logs UI-related messages
    static func ui(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: level, logger: uiLogger, file: file, function: function, line: line)
    }
    
    /// Logs data-related messages
    static func data(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: level, logger: dataLogger, file: file, function: function, line: line)
    }
    
    /// Logs general messages
    static func general(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: level, logger: generalLogger, file: file, function: function, line: line)
    }
    
    // MARK: - Private Methods
    
    private static func log(_ message: String, level: LogLevel, logger: OSLog, file: String, function: String, line: Int) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "\(level.rawValue) [\(fileName):\(line)] \(function) - \(message)"
        
        let osLogType: OSLogType = switch level {
        case .debug: .debug
        case .info: .info
        case .warning: .default
        case .error: .error
        case .success: .info
        }
        
        os_log("%{public}@", log: logger, type: osLogType, logMessage)
        #endif
    }
}

// MARK: - Convenience Extensions
extension Logger {
    /// Logs error with details
    static func logError(_ error: Error, context: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        let errorMessage = """
        \(context.isEmpty ? "" : "\(context): ")
        Error: \(error.localizedDescription)
        """
        general(errorMessage, level: .error, file: file, function: function, line: line)
    }
    
    /// Logs network request
    static func logRequest(url: String, method: String = "GET") {
        network("📤 Request: \(method) \(url)", level: .info)
    }
    
    /// Logs network response
    static func logResponse(url: String, statusCode: Int) {
        let level: LogLevel = (200...299).contains(statusCode) ? .success : .error
        network("📥 Response: \(statusCode) for \(url)", level: level)
    }
}
