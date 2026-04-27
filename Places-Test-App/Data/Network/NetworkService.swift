//
//  NetworkService.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation

// MARK: - Network Service Implementation
final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Properties
    private let session: URLSession
    private let decoder: JSONDecoder
    
    // MARK: - Initialization
    init(
        session: URLSession? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        timeout: TimeInterval = 30
    ) {
        if let session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = timeout
            configuration.timeoutIntervalForResource = timeout
            self.session = URLSession(configuration: configuration)
        }
        self.decoder = decoder
    }
    
    // MARK: - Public Methods
    
    /// Generic fetch method that works with any Decodable type
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        Logger.network("Fetching from: \(url.absoluteString)", level: .info)
        
        // Perform network request
        let (data, response) = try await session.data(from: url)
        
        // Validate response
        guard let httpResponse = response as? HTTPURLResponse else {
            Logger.network("Invalid HTTP response", level: .error)
            throw NetworkError.invalidResponse
        }
        
        Logger.logResponse(url: url.absoluteString, statusCode: httpResponse.statusCode)
        
        // Check status code
        guard (200...299).contains(httpResponse.statusCode) else {
            Logger.network("Server error: \(httpResponse.statusCode)", level: .error)
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        // Decode data
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            Logger.network("Successfully decoded \(String(describing: T.self))", level: .success)
            return decodedData
        } catch {
            Logger.network("Decoding failed: \(error.localizedDescription)", level: .error)
            throw NetworkError.decodingError(error)
        }
    }
}

// MARK: - Network Service Extensions
extension NetworkService {
    /// Convenience method to fetch from URL string
    func fetch<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        return try await fetch(from: url)
    }
}
