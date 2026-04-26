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
        locationsURL: String = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
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
            let locations: [Location] = try await networkService.fetch(from: url)
            let validLocations = locations.filter { $0.isValid }
            return validLocations
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
