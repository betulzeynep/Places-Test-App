//
//  DependencyContainer.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation

// MARK: - Dependency Container
/// Simple dependency injection container following Factory pattern
/// Manages creation and lifecycle of app dependencies
final class DependencyContainer {
    
    // MARK: - Singleton
    static let shared = DependencyContainer()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Network Layer
    
    /// Creates NetworkService instance
    /// - Returns: NetworkServiceProtocol implementation
    func makeNetworkService() -> NetworkServiceProtocol {
        NetworkService()
    }
    
    // MARK: - Repository Layer
    
    /// Creates LocationRepository instance
    /// - Returns: LocationRepositoryProtocol implementation
    func makeLocationRepository() -> LocationRepositoryProtocol {
        LocationRepository(
            networkService: makeNetworkService()
        )
    }
    
    // MARK: - Use Cases
    
    /// Creates FetchLocationsUseCase instance
    /// - Returns: FetchLocationsUseCaseProtocol implementation
    func makeFetchLocationsUseCase() -> FetchLocationsUseCaseProtocol {
        FetchLocationsUseCase(
            repository: makeLocationRepository()
        )
    }
    
    /// Creates OpenWikipediaUseCase instance
    /// - Returns: OpenWikipediaUseCaseProtocol implementation
    func makeOpenWikipediaUseCase() -> OpenWikipediaUseCaseProtocol {
        OpenWikipediaUseCase()
    }
    
    // MARK: - View Models
    
    /// Creates LocationsViewModel instance
    /// - Returns: Configured LocationsViewModel
    func makeLocationsViewModel() -> LocationsViewModel {
        LocationsViewModel(
            fetchLocationsUseCase: makeFetchLocationsUseCase(),
            openWikipediaUseCase: makeOpenWikipediaUseCase()
        )
    }
}

// MARK: - Testing Support
#if DEBUG
extension DependencyContainer {
    /// Creates a container for testing with mock dependencies
    static func makeTestContainer(
        networkService: NetworkServiceProtocol? = nil,
        repository: LocationRepositoryProtocol? = nil
    ) -> DependencyContainer {
        let container = DependencyContainer()
        // Test dependencies can be injected here
        return container
    }
}
#endif
