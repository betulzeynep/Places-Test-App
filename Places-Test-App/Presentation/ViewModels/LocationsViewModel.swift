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
        
        do {
            locations = try await fetchLocationsUseCase.execute()
            errorMessage = nil
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
            locations = []
        } catch {
            errorMessage = "An unexpected error occurred."
            locations = []
        }
        
        isLoading = false
    }
    
    /// Opens Wikipedia app for a specific location
    /// - Parameter location: The location to open in Wikipedia
    func openLocation(_ location: Location) {
        Task {
            let success = await openWikipediaUseCase.execute(latitude: location.lat, longitude: location.lon)
            
            if !success {
                errorMessage = "Cannot open Wikipedia app. Make sure it's installed."
            }
        }
    }

    /// Opens Wikipedia app for custom coordinates
    /// - Parameters:
    ///   - latitude: Custom latitude
    ///   - longitude: Custom longitude
    func openCustomLocation(latitude: Double, longitude: Double) {
        // Validate coordinates first
        guard LocationValidation.isValidCoordinates(latitude: latitude, longitude: longitude) else {
            errorMessage = "Invalid coordinates. Latitude must be between -90 and 90, longitude between -180 and 180."
            return
        }
        
        Task {
            let success = await openWikipediaUseCase.execute(latitude: latitude, longitude: longitude)
            
            if !success {
                errorMessage = "Cannot open Wikipedia app. Make sure it's installed."
            }
        }
    }
    
    /// Clears current error message
    func clearError() {
        errorMessage = nil
    }
}
