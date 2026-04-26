//
//  LocationRepositoryProtocol.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation

// MARK: - Location Repository Protocol
protocol LocationRepositoryProtocol {
    /// Fetches locations from remote source
    func fetchLocations() async throws -> [Location]
}
