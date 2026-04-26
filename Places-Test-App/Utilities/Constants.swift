//
//  Constants.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation

// MARK: - App Constants
enum Constants {
    
    // MARK: - API
    enum API {
        static let locationsURL = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
        static let timeoutInterval: TimeInterval = 30
    }
    
    // MARK: - Deep Link
    enum DeepLink {
        static let wikipediaScheme = "wikipedia://places"
        static let wikipediaURLScheme = "wikipedia"
    }
    
    // MARK: - Validation
    enum Validation {
        static let latitudeMin: Double = -90.0
        static let latitudeMax: Double = 90.0
        static let longitudeMin: Double = -180.0
        static let longitudeMax: Double = 180.0
        
        static let latitudeRange = latitudeMin...latitudeMax
        static let longitudeRange = longitudeMin...longitudeMax
    }
    
    // MARK: - UI
    enum UI {
        static let loadingScaleEffect: CGFloat = 1.5
        static let errorOverlayOpacity: Double = 0.2
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 4
        static let coordinatePrecision: Int = 2
        static let coordinateDisplayPrecision: String = "%.4f"
    }
    
    // MARK: - Default Values
    enum Defaults {
        static let unknownLocationName = "Unknown Location"
        static let emptyFieldValue = "Empty"
    }
    
    // MARK: - Accessibility
    enum Accessibility {
        enum Identifiers {
            static let customLocationNameField = "customLocationNameField"
            static let latitudeField = "latitudeField"
            static let longitudeField = "longitudeField"
            static let openWikipediaButton = "openWikipediaButton"
            
            static func locationItem(_ name: String) -> String {
                "location_\(name.replacingOccurrences(of: " ", with: "_"))"
            }
        }
    }
}
