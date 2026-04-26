//
//  Location.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation

// MARK: - Model
struct Location: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let lat: Double
    let lon: Double
    
    enum CodingKeys: String, CodingKey {
        case name, lat, lon
    }
    
    // MARK: - Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.lat == rhs.lat &&
        lhs.lon == rhs.lon
    }
}

// MARK: - Helpers
extension Location {
    /// Validates if location coordinates are valid
    var isValid: Bool {
        LocationValidation.isValidCoordinates(latitude: lat, longitude: lon)
    }
    
    /// Creates a custom location
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.lat = latitude
        self.lon = longitude
    }
}
