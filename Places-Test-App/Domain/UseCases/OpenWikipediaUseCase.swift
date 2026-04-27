//
//  OpenWikipediaUseCase.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation
import UIKit

// MARK: - Open Wikipedia Use Case Protocol
protocol OpenWikipediaUseCaseProtocol {
    func execute(latitude: Double, longitude: Double) -> Bool
    func execute(latitude: Double, longitude: Double, locationName: String?) -> Bool
    func execute(locationName: String) -> Bool
    func execute(linkType: Constants.DeepLink.LinkType) -> Bool
}

// MARK: - Open Wikipedia Use Case Implementation
final class OpenWikipediaUseCase: OpenWikipediaUseCaseProtocol {
    
    // MARK: - Properties
    private let urlScheme: String
    
    // MARK: - Initialization
    init(urlScheme: String = Constants.DeepLink.wikipediaScheme) {
        self.urlScheme = urlScheme
    }
    
    // MARK: - Public Methods
    
    /// Opens Wikipedia Places tab with coordinates only
    func execute(latitude: Double, longitude: Double) -> Bool {
        let linkType = Constants.DeepLink.LinkType.placesWithCoordinates(lat: latitude, lon: longitude)
        return execute(linkType: linkType)
    }
    
    /// Opens Wikipedia with coordinates and optional article
    /// - If name provided: Opens Places tab with article URL (wikipedia://places?WMFArticleURL=...)
    /// - If no name: Opens Places tab with coordinates (wikipedia://places?lat=X&lon=Y)
    func execute(latitude: Double, longitude: Double, locationName: String?) -> Bool {
        // Validate coordinates
        guard LocationValidation.isValidCoordinates(latitude: latitude, longitude: longitude) else {
            Logger.network("Invalid coordinates: lat=\(latitude), lon=\(longitude)", level: .error)
            return false
        }
        
        // Determine link type
        let linkType: Constants.DeepLink.LinkType
        
        if let name = locationName,
           !name.isEmpty,
           name != Constants.Defaults.unknownLocationName {
            // Has valid name - use Places tab with article URL
            let articleURL = Constants.DeepLink.wikipediaArticleURL(for: name)
            linkType = .placesWithArticle(articleURL: articleURL)
            Logger.network("Opening Places tab with article for: \(name)", level: .info)
        } else {
            // No name - use Places tab with coordinates
            linkType = .placesWithCoordinates(lat: latitude, lon: longitude)
            Logger.network("Opening Places tab with coordinates: lat=\(latitude), lon=\(longitude)", level: .info)
        }
        
        return execute(linkType: linkType)
    }
    
    /// Opens Wikipedia with specified link type
    func execute(linkType: Constants.DeepLink.LinkType) -> Bool {
        let urlString = linkType.urlString
        
        guard let url = URL(string: urlString) else {
            Logger.network("Failed to create URL: \(urlString)", level: .error)
            return false
        }
        
        Logger.network("Opening Wikipedia (\(linkType.description)): \(urlString)", level: .info)
        
        // Check if Wikipedia app can be opened
        guard UIApplication.shared.canOpenURL(url) else {
            Logger.network("Wikipedia app not available on device", level: .warning)
            return false
        }
        
        // Open Wikipedia app
        UIApplication.shared.open(url, options: [:]) { success in
            if success {
                Logger.network("Successfully opened Wikipedia with \(linkType.description)", level: .success)
            } else {
                Logger.network("Failed to open Wikipedia app", level: .error)
            }
        }
        
        return true
    }
    
    /// Opens Wikipedia with location name only (no coordinates)
    /// Uses direct article link
    func execute(locationName: String) -> Bool {
        guard !locationName.isEmpty else {
            Logger.network("Empty location name provided", level: .error)
            return false
        }
        
        let articleURL = Constants.DeepLink.wikipediaArticleURL(for: locationName)
        let linkType = Constants.DeepLink.LinkType.placesWithArticle(articleURL: articleURL)
        
        Logger.network("Opening Wikipedia with name only: \(locationName)", level: .info)
        
        return execute(linkType: linkType)
    }
}

// MARK: - Convenience Extensions
extension OpenWikipediaUseCase {
    /// Opens Wikipedia for a Location object
    /// Uses name if available (Places + Article), otherwise coordinates only (Places + Map)
    func execute(for location: Location) -> Bool {
        execute(latitude: location.lat, longitude: location.lon, locationName: location.name)
    }
}
