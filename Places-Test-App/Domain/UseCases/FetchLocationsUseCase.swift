//
//  FetchLocationsUseCase.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation

// MARK: - Fetch Locations Use Case Protocol
protocol FetchLocationsUseCaseProtocol {
    func execute() async throws -> [Location]
}

// MARK: - Fetch Locations Use Case Implementation
final class FetchLocationsUseCase: FetchLocationsUseCaseProtocol {
    
    // MARK: - Properties
    private let repository: LocationRepositoryProtocol
    
    // MARK: - Initialization
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    
    /// Executes the use case to fetch locations
    /// - Returns: Array of valid locations
    /// - Throws: NetworkError if fetching fails
    func execute() async throws -> [Location] {
        // Fetch locations from repository
        let locations = try await repository.fetchLocations()
        
        // Additional business logic can be added here
        // For example: sorting, filtering, caching, etc.
        
        // Sort by name for consistent UI display
        let sortedLocations = locations.sorted { $0.name < $1.name }
        
        return sortedLocations
    }
}
