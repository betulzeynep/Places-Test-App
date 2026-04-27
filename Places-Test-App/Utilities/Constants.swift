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
        
        // New UI constants
        static let largeCornerRadius: CGFloat = 16
        static let iconSize: CGFloat = 40
        static let iconBackgroundOpacity: Double = 0.1
        static let largeShadowRadius: CGFloat = 10
        static let smallSpacing: CGFloat = 8
        static let mediumSpacing: CGFloat = 12
        static let largeSpacing: CGFloat = 16
        static let extraLargeSpacing: CGFloat = 24
        static let extraExtraLargeSpacing: CGFloat = 40
        static let emptyStateIconSize: CGFloat = 60
        static let dismissButtonPadding: CGFloat = 8
        static let whiteBackgroundOpacity: Double = 0.2
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
        
        enum Messages {
            static let loadingLocations = "Loading locations"
            static let loadingUpdating = "Loading locations. This may take a few moments."
            static let emptyStateMessage = "No locations available. Pull to refresh or check your connection."
            static let locationButtonHint = "Double tap to open this location in Wikipedia"
            static let dismissErrorHint = "Removes this error message"
            static let dismissErrorLabel = "Dismiss error"
            static let errorLabel = "Error"
            static let noLocations = "No Locations"
            static let pullToRefresh = "Pull to refresh or check your connection"
        }
    }
    
    // MARK: - UI Text
    enum UIText {
        static let loadingMessage = "Loading locations..."
        static let noLocationsTitle = "No Locations"
        static let noLocationsMessage = "Pull to refresh or check your connection"
        static let locationsHeaderTitle = "Locations"
        static let customLocationHeaderTitle = "Custom Location"
        static let customLocationFooter = "Search for historical landmarks and points of interest based on custom coordinates."
        
        static func locationsCount(_ count: Int) -> String {
            "\(count) location(s) available"
        }
    }
}
