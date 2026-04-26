//
//  AppError.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation

// MARK: - App Error Protocol
/// Base protocol for all app errors with user-facing and technical messages
protocol AppError: LocalizedError {
    /// User-friendly error message
    var userMessage: String { get }
    
    /// Technical error message for logging
    var technicalMessage: String { get }
    
    /// Recovery suggestion for the user
    var userRecoverySuggestion: String? { get }
}

// MARK: - Default Implementation
extension AppError {
    var errorDescription: String? {
        userMessage
    }
    
    var failureReason: String? {
        technicalMessage
    }
}

// MARK: - Network Errors
enum NetworkError: AppError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int)
    case noInternetConnection
    case timeout
    case unknown(Error)
    
    var userMessage: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidResponse:
            return "Invalid response from server."
        case .decodingError:
            return "Failed to process data. The format may have changed."
        case .serverError(let statusCode):
            return "Server error (\(statusCode)). Please try again later."
        case .noInternetConnection:
            return "No internet connection. Please check your network settings."
        case .timeout:
            return "Request timed out. Please try again."
        case .unknown:
            return "An unexpected network error occurred."
        }
    }
    
    var technicalMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .invalidResponse:
            return "HTTP response validation failed"
        case .decodingError(let error):
            return "JSON decoding failed: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server returned error status code: \(statusCode)"
        case .noInternetConnection:
            return "No internet connection detected"
        case .timeout:
            return "Network request timed out"
        case .unknown(let error):
            return "Unknown network error: \(error.localizedDescription)"
        }
    }
    
    var recoverySuggestion: String? {
        userRecoverySuggestion
    }
    
    var userRecoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Please contact support if this issue persists."
        case .invalidResponse, .decodingError:
            return "The data format may have changed. Please try again later or contact support."
        case .serverError:
            return "The server is experiencing issues. Please try again later."
        case .noInternetConnection:
            return "Connect to the internet and try again."
        case .timeout:
            return "Check your connection speed and try again."
        case .unknown:
            return "Please try again or contact support if the issue persists."
        }
    }
}

// MARK: - Validation Errors
enum ValidationError: AppError {
    case invalidCoordinates
    case coordinatesOutOfRange
    case invalidLatitude(Double)
    case invalidLongitude(Double)
    case invalidInput(String)
    case emptyInput
    
    var userMessage: String {
        switch self {
        case .invalidCoordinates:
            return "Invalid coordinates. Latitude must be between -90 and 90, longitude between -180 and 180."
        case .coordinatesOutOfRange:
            return "Coordinates are out of valid range."
        case .invalidLatitude(let value):
            return "Invalid latitude (\(value)). Must be between -90 and 90."
        case .invalidLongitude(let value):
            return "Invalid longitude (\(value)). Must be between -180 and 180."
        case .invalidInput(let input):
            return "'\(input)' is not a valid number."
        case .emptyInput:
            return "Please enter coordinates."
        }
    }
    
    var technicalMessage: String {
        switch self {
        case .invalidCoordinates:
            return "Coordinate validation failed"
        case .coordinatesOutOfRange:
            return "Coordinates out of valid range"
        case .invalidLatitude(let value):
            return "Latitude validation failed: \(value)"
        case .invalidLongitude(let value):
            return "Longitude validation failed: \(value)"
        case .invalidInput(let input):
            return "Invalid input: \(input)"
        case .emptyInput:
            return "Empty coordinate input"
        }
    }
    
    var recoverySuggestion: String? {
        userRecoverySuggestion
    }
    
    var userRecoverySuggestion: String? {
        switch self {
        case .invalidCoordinates, .coordinatesOutOfRange:
            return "Please enter valid latitude (-90 to 90) and longitude (-180 to 180) values."
        case .invalidLatitude:
            return "Latitude must be between -90 and 90 degrees."
        case .invalidLongitude:
            return "Longitude must be between -180 and 180 degrees."
        case .invalidInput:
            return "Please enter numbers only. Use dot (.) for decimal separator."
        case .emptyInput:
            return "Both latitude and longitude are required."
        }
    }
}

// MARK: - Deep Link Errors
enum DeepLinkError: AppError {
    case wikipediaNotInstalled
    case wikipediaOpenFailed
    case invalidDeepLinkURL
    case cannotOpenURL(String)
    
    var userMessage: String {
        switch self {
        case .wikipediaNotInstalled:
            return "Cannot open Wikipedia app. Make sure it's installed."
        case .wikipediaOpenFailed:
            return "Failed to open Wikipedia app. Please try again."
        case .invalidDeepLinkURL:
            return "Invalid deep link format."
        case .cannotOpenURL:
            return "Cannot open the requested location."
        }
    }
    
    var technicalMessage: String {
        switch self {
        case .wikipediaNotInstalled:
            return "Wikipedia app not found on device"
        case .wikipediaOpenFailed:
            return "Failed to open Wikipedia URL"
        case .invalidDeepLinkURL:
            return "Deep link URL creation failed"
        case .cannotOpenURL(let url):
            return "Cannot open URL: \(url)"
        }
    }
    
    var recoverySuggestion: String? {
        userRecoverySuggestion
    }
    
    var userRecoverySuggestion: String? {
        switch self {
        case .wikipediaNotInstalled:
            return "Install Wikipedia app from the App Store."
        case .wikipediaOpenFailed:
            return "Make sure Wikipedia app is installed and up to date."
        case .invalidDeepLinkURL:
            return "Please contact support if this issue persists."
        case .cannotOpenURL:
            return "Check if the Wikipedia app is installed and working correctly."
        }
    }
}

// MARK: - Data Errors
enum DataError: AppError {
    case fetchFailed
    case parseFailed
    case noData
    case invalidData
    
    var userMessage: String {
        switch self {
        case .fetchFailed:
            return "Failed to load data. Please try again."
        case .parseFailed:
            return "Failed to process data."
        case .noData:
            return "No data available."
        case .invalidData:
            return "Invalid data format."
        }
    }
    
    var technicalMessage: String {
        switch self {
        case .fetchFailed:
            return "Data fetch operation failed"
        case .parseFailed:
            return "Data parsing failed"
        case .noData:
            return "No data returned from source"
        case .invalidData:
            return "Data validation failed"
        }
    }
    
    var recoverySuggestion: String? {
        userRecoverySuggestion
    }
    
    var userRecoverySuggestion: String? {
        switch self {
        case .fetchFailed:
            return "Check your internet connection and try again."
        case .parseFailed:
            return "The data format may have changed. Please try again later."
        case .noData:
            return "Try refreshing the data."
        case .invalidData:
            return "Please contact support if this issue persists."
        }
    }
}

// MARK: - Generic App Error
enum GenericError: AppError {
    case unexpected
    case unknown(Error)
    case notImplemented
    
    var userMessage: String {
        switch self {
        case .unexpected:
            return "An unexpected error occurred."
        case .unknown:
            return "Something went wrong. Please try again."
        case .notImplemented:
            return "This feature is not yet available."
        }
    }
    
    var technicalMessage: String {
        switch self {
        case .unexpected:
            return "Unexpected error occurred"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        case .notImplemented:
            return "Feature not implemented"
        }
    }
    
    var recoverySuggestion: String? {
        userRecoverySuggestion
    }
    
    var userRecoverySuggestion: String? {
        switch self {
        case .unexpected, .unknown:
            return "Please try again or contact support if the issue persists."
        case .notImplemented:
            return "This feature will be available in a future update."
        }
    }
}

// MARK: - Error Conversion Helper
extension Error {
    /// Converts any Error to AppError
    var asAppError: AppError {
        if let appError = self as? AppError {
            return appError
        }
        return GenericError.unknown(self)
    }
    
    /// Gets user-facing message from any Error
    var userMessage: String {
        asAppError.userMessage
    }
    
    /// Gets technical message from any Error
    var technicalMessage: String {
        asAppError.technicalMessage
    }
}
