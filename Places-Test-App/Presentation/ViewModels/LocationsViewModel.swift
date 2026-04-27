//
//  LocationsViewModel.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Combine
import Foundation

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
            Logger.ui(
                "Successfully loaded \(locations.count) locations",
                level: .success
            )
        } catch let error as NetworkError {
            errorMessage = error.userMessage
            locations = []
            Logger.logError(error, context: "Failed to fetch locations")
        } catch {
            let appError = error.asAppError
            errorMessage = appError.userMessage
            locations = []
            Logger.logError(
                error,
                context: "Unexpected error fetching locations"
            )
        }

        isLoading = false
    }

    /// Opens Wikipedia app for a specific location
    /// - Parameter location: The location to open in Wikipedia
    func openLocation(_ location: Location) {
        Logger.ui("Opening Wikipedia for: \(location.name)", level: .info)

        let success = openWikipediaUseCase.execute(
            latitude: location.lat,
            longitude: location.lon
        )

        if !success {
            let error = DeepLinkError.wikipediaNotInstalled
            errorMessage = error.userMessage
            Logger.ui(error.technicalMessage, level: .error)
        }
    }
    
    /// Opens Wikipedia with mode-based input (name or coordinates)
    /// - Parameters:
    ///   - latitude: Optional latitude
    ///   - longitude: Optional longitude
    ///   - name: Optional location name
    func openCustomLocation(
        latitude: Double?,
        longitude: Double?,
        name: String?
    ) {
        if let locationName = name, !locationName.isEmpty {
            Logger.ui(
                "Opening Wikipedia with name only: \(locationName)",
                level: .info
            )
            let success = openWikipediaUseCase.execute(
                locationName: locationName
            )

            if !success {
                let error = DeepLinkError.wikipediaOpenFailed
                errorMessage = error.userMessage
                Logger.ui(error.technicalMessage, level: .error)
            }
            return
        }

        if let lat = latitude, let lon = longitude {
            guard
                LocationValidation.isValidCoordinates(
                    latitude: lat,
                    longitude: lon
                )
            else {
                let error = ValidationError.invalidCoordinates
                errorMessage = error.userMessage
                Logger.ui(error.technicalMessage, level: .warning)
                return
            }

            Logger.ui(
                "Opening Wikipedia with coordinates only: lat=\(lat), lon=\(lon)",
                level: .info
            )
            let success = openWikipediaUseCase.execute(
                latitude: lat,
                longitude: lon
            )

            if !success {
                let error = DeepLinkError.wikipediaOpenFailed
                errorMessage = error.userMessage
                Logger.ui(error.technicalMessage, level: .error)
            }
            return
        }

        // Invalid input
        let error = ValidationError.invalidInput("location")
        errorMessage = error.userMessage
        Logger.ui("Invalid custom location input", level: .warning)
    }

    /// Clears current error message
    func clearError() {
        errorMessage = nil
    }
}
