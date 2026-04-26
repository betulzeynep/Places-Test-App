//
//  LocationValidation.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation

// MARK: - Location Validation Helper
struct LocationValidation {
    
    // MARK: - Validation Rules
    static let latitudeRange = -90.0...90.0
    static let longitudeRange = -180.0...180.0
    
    // MARK: - Public Methods
    
    /// Validates if latitude is within valid range
    static func isValidLatitude(_ latitude: Double) -> Bool {
        latitudeRange.contains(latitude)
    }
    
    /// Validates if longitude is within valid range
    static func isValidLongitude(_ longitude: Double) -> Bool {
        longitudeRange.contains(longitude)
    }
    
    /// Validates both coordinates
    static func isValidCoordinates(latitude: Double, longitude: Double) -> Bool {
        isValidLatitude(latitude) && isValidLongitude(longitude)
    }
    
    /// Parses string to double, handling both comma and dot as decimal separator
    static func parseCoordinate(_ text: String) -> Double? {
        // Remove whitespace
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        
        // Try parsing with current locale first
        if let value = Double(trimmed) {
            return value
        }
        
        // Try replacing comma with dot
        let withDot = trimmed.replacingOccurrences(of: ",", with: ".")
        if let value = Double(withDot) {
            return value
        }
        
        // Try with locale-aware parsing
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        
        if let number = formatter.number(from: trimmed) {
            return number.doubleValue
        }
        
        return nil
    }
    
    /// Sanitizes input by removing invalid characters
    static func sanitizeCoordinateInput(_ text: String) -> String {
        // Allow: digits, minus sign, dot, comma
        let allowedCharacters = CharacterSet(charactersIn: "0123456789-.,")
        let filtered = text.unicodeScalars.filter { allowedCharacters.contains($0) }
        var result = String(String.UnicodeScalarView(filtered))
        
        // Ensure only one decimal separator
        let dotCount = result.filter { $0 == "." }.count
        let commaCount = result.filter { $0 == "," }.count
        
        if dotCount > 1 || commaCount > 1 || (dotCount > 0 && commaCount > 0) {
            // Keep only first decimal separator
            var foundSeparator = false
            result = String(result.compactMap { char in
                if char == "." || char == "," {
                    if foundSeparator {
                        return nil
                    }
                    foundSeparator = true
                }
                return char
            })
        }
        
        // Ensure minus only at the beginning
        if result.contains("-") {
            let firstChar = result.first == "-" ? "-" : ""
            let rest = result.filter { $0 != "-" }
            result = firstChar + rest
        }
        
        return result
    }
}
