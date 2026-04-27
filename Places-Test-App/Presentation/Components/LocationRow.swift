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
        HStack(spacing: Constants.UI.mediumSpacing) {
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(location.displayName)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                HStack(spacing: 8) {
                    Text("Lat: \(location.lat, format: .number.precision(.fractionLength(4)))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Latitude \(location.lat, specifier: Constants.UI.coordinateDisplayPrecision)")
                    
                    Text("•")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .accessibilityHidden(true)
                    
                    Text("Lon: \(location.lon, format: .number.precision(.fractionLength(4)))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Longitude \(location.lon, specifier: Constants.UI.coordinateDisplayPrecision)")
                }
            }
            
            Spacer()
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
        .accessibilityHint(Constants.Accessibility.Messages.locationButtonHint)
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Accessibility Helper
    private var accessibilityDescription: String {
        let latDirection = location.lat >= 0 ? "North" : "South"
        let lonDirection = location.lon >= 0 ? "East" : "West"
        let latValue = String(format: "%.2f", abs(location.lat))
        let lonValue = String(format: "%.2f", abs(location.lon))

        return
            "\(location.displayName), Latitude \(latValue) degrees \(latDirection), Longitude \(lonValue) degrees \(lonDirection)"
    }
}

// MARK: - Preview
#Preview {
    List {
        LocationRow(
            location: Location(
                name: "Amsterdam",
                latitude: 52.3676,
                longitude: 4.9041
            )
        )
        LocationRow(
            location: Location(
                name: "Istanbul",
                latitude: 41.0082,
                longitude: 28.9784
            )
        )
    }
}
