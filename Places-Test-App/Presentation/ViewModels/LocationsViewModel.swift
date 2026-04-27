//
//  LocationsViewModel.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation
import Combine

// MARK: - Locations View Model
@MainActor
final class LocationsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var locations: [Location] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
    // MARK: - Dependencies
    private let fetchLocationsUseCase: FetchLocationsUseCaseProtocol
    private let openWikipediaUseCase: OpenWikipediaUseCaseProtocol
    
    // MARK: - Initialization
    init(
        fetchLocationsUseCase: FetchLocationsUseCaseProtocol,
        openWikipediaUseCase: OpenWikipediaUseCaseProtocol
    ) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
        self.openWikipediaUseCase = openWikipediaUseCase
    }
    
    // MARK: - Public Methods
    
    /// Fetches locations from remote source
    func fetchLocations() async {
        isLoading = true
        errorMessage = nil
        
        Logger.ui("Fetching locations", level: .info)
        
        do {
            locations = try await fetchLocationsUseCase.execute()
            errorMessage = nil
            Logger.ui("Successfully loaded \(locations.count) locations", level: .success)
        } catch let error as NetworkError {
            errorMessage = error.userMessage
            locations = []
            Logger.logError(error, context: "Failed to fetch locations")
        } catch {
            let appError = error.asAppError
            errorMessage = appError.userMessage
            locations = []
            Logger.logError(error, context: "Unexpected error fetching locations")
        }
        
        isLoading = false
    }
    
    /// Opens Wikipedia app for a specific location
    /// - Parameter location: The location to open in Wikipedia
    func openLocation(_ location: Location) {
        Logger.ui("Opening Wikipedia for: \(location.name)", level: .info)
        
        let success = openWikipediaUseCase.execute(latitude: location.lat, longitude: location.lon)
        
        if !success {
            let error = DeepLinkError.wikipediaNotInstalled
            errorMessage = error.userMessage
            Logger.ui(error.technicalMessage, level: .error)
        }
    }
    
    /// Opens Wikipedia app for custom coordinates
    /// - Parameters:
    ///   - latitude: Custom latitude
    ///   - longitude: Custom longitude
    func openCustomLocation(latitude: Double, longitude: Double) {
        // Validate coordinates first
        guard LocationValidation.isValidCoordinates(latitude: latitude, longitude: longitude) else {
            let error = ValidationError.invalidCoordinates
            errorMessage = error.userMessage
            Logger.ui(error.technicalMessage, level: .warning)
            return
        }
        
        Logger.ui("Opening custom location: lat=\(latitude), lon=\(longitude)", level: .info)
        
        let success = openWikipediaUseCase.execute(latitude: latitude, longitude: longitude)
        
        if !success {
            let error = DeepLinkError.wikipediaOpenFailed
            errorMessage = error.userMessage
            Logger.ui(error.technicalMessage, level: .error)
        }
    }
    
    /// Clears current error message
    func clearError() {
        errorMessage = nil
    }
}
