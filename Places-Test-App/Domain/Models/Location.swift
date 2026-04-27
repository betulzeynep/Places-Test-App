//
//  Location.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Foundation

// MARK: - Model
struct Location: Codable, Identifiable, Equatable {
    let name: String
    let lat: Double
    let lon: Double
    
    /// Stable identifier based on location payload.
    var id: String {
        "\(name)|\(lat)|\(lon)"
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case lat
        case lon = "long"
    }
    
    // Custom decoder for optional name
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Name is optional in JSON, provide default if missing
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? Constants.Defaults.unknownLocationName
        lat = try container.decode(Double.self, forKey: .lat)
        lon = try container.decode(Double.self, forKey: .lon)
    }
    
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
    }
    
}


// MARK: - Helpers
extension Location {
    /// Validates if location coordinates are valid
    var isValid: Bool {
        LocationValidation.isValidCoordinates(latitude: lat, longitude: lon)
    }
    
    /// Creates a custom location (for manual input)
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.lat = latitude
        self.lon = longitude
    }
    
    /// Display name showing coordinates for unknown locations
    var displayName: String {
        if name == Constants.Defaults.unknownLocationName {
            let precision = Constants.UI.coordinatePrecision
            return "Location (\(lat.formatted(.number.precision(.fractionLength(precision)))), \(lon.formatted(.number.precision(.fractionLength(precision)))))"
        }
        return name
    }
}
