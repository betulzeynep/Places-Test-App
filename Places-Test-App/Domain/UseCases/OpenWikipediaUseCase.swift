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
}

// MARK: - Open Wikipedia Use Case Implementation
final class OpenWikipediaUseCase: OpenWikipediaUseCaseProtocol {
    
    // MARK: - Properties
    private let urlScheme: String
    
    // MARK: - Initialization
    init(urlScheme: String = "wikipedia://places") {
        self.urlScheme = urlScheme
    }
    
    // MARK: - Public Methods
    
    /// Opens Wikipedia app at the specified location
    /// - Parameters:
    ///   - latitude: Location latitude
    ///   - longitude: Location longitude
    /// - Returns: true if the app was opened successfully, false otherwise
    func execute(latitude: Double, longitude: Double) -> Bool {
        // Validate coordinates before creating URL
        guard LocationValidation.isValidCoordinates(latitude: latitude, longitude: longitude) else {
            return false
        }
        
        // Create deep link URL
        let urlString = "\(urlScheme)?lat=\(latitude)&lon=\(longitude)"
        
        guard let url = URL(string: urlString) else {
            return false
        }
        
        // Check if Wikipedia app can be opened
        guard UIApplication.shared.canOpenURL(url) else {
            return false
        }
        
        // Open Wikipedia app
        UIApplication.shared.open(url, options: [:]) { success in
            if !success {
                print("Failed to open Wikipedia app")
            }
        }
        
        return true
    }
}

// MARK: - Convenience Extensions
extension OpenWikipediaUseCase {
    /// Opens Wikipedia app for a given Location
    /// - Parameter location: The location to open
    /// - Returns: true if successful, false otherwise
    func execute(for location: Location) -> Bool {
        execute(latitude: location.lat, longitude: location.lon)
    }
}
