//
//  NetworkServiceProtocol.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(from url: URL) async throws -> T
   // func fetch<T: Decodable>(from urlString: String) async throws -> T
}
