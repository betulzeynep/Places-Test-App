//
//  LocationRow.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import SwiftUI

// MARK: - Location Row
struct LocationRow: View {
    
    // MARK: - Properties
    let location: Location
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text("Lat: \(location.lat, specifier: "%.4f"), Lon: \(location.lon, specifier: "%.4f")")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
        .accessibilityHint("Double tap to open this location in Wikipedia")
        .accessibilityAddTraits(.isButton)  // It's a button
    }
    
    // MARK: - Accessibility Helper
    private var accessibilityDescription: String {
        let latText = location.lat >= 0 ? "North \(abs(location.lat))" : "South \(abs(location.lat))"
        let lonText = location.lon >= 0 ? "East \(abs(location.lon))" : "West \(abs(location.lon))"
        return "\(location.name), Latitude \(latText) degrees, Longitude \(lonText) degrees"
    }
}

// MARK: - Preview
#Preview {
    List {
        LocationRow(location: Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041))
        LocationRow(location: Location(name: "Istanbul", latitude: 41.0082, longitude: 28.9784))
    }
}
