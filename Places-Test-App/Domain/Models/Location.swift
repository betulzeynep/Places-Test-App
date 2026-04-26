//
//  Location.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation

// MARK: - Model
struct Location: Codable, Identifiable {
    let id = UUID()
    let name: String
    let lat: Double
    let lon: Double
    
    enum CodingKeys: String, CodingKey {
        case name, lat, lon
    }
}
