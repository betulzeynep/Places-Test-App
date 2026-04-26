//
//  LocationRepository.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation

// MARK: - Location Repository Implementation
final class LocationRepository: LocationRepositoryProtocol {
    
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol
    private let locationsURL: String
    
    // MARK: - Initialization
    init(
        networkService: NetworkServiceProtocol,
        locationsURL: String = Constants.API.locationsURL
    ) {
        self.networkService = networkService
        self.locationsURL = locationsURL
    }
    
    // MARK: - Public Methods
    
    /// Fetches locations from the remote JSON source
    func fetchLocations() async throws -> [Location] {
        guard let url = URL(string: locationsURL) else {
            throw NetworkError.invalidURL
        }
        
        do {
            // Fetch wrapped response
            let response: LocationResponse = try await networkService.fetch(from: url)
            
            // Validate locations (filter out invalid coordinates)
            let validLocations = response.locations.filter { $0.isValid }
            
            return validLocations
        } catch let error as NetworkError {
            // Re-throw NetworkError as is
            throw error
        } catch {
            // Wrap unknown errors
            throw NetworkError.unknown(error)
        }
    }
}
