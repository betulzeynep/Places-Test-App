//
//  CustomLocationInputView.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import SwiftUI

// MARK: - Custom Location Input View
struct CustomLocationInputView: View {
    
    // MARK: - Bindings
    @Binding var name: String
    @Binding var latitude: String
    @Binding var longitude: String
    
    // MARK: - Properties
    let onSubmit: (Double, Double) -> Void
    
    // MARK: - State
    @State private var validationError: String?
    
    // MARK: - Computed Properties
    private var isInputValid: Bool {
        guard let lat = LocationValidation.parseCoordinate(latitude),
              let lon = LocationValidation.parseCoordinate(longitude) else {
            return false
        }
        return LocationValidation.isValidCoordinates(latitude: lat, longitude: lon)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Location Name (optional)", text: $name)
                .textFieldStyle(.roundedBorder)
                .accessibilityLabel("Location name")
                .accessibilityHint("Optional. Enter a name for this location")
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Latitude")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    TextField("-90 to 90", text: $latitude)
                        .accessibilityLabel("Latitude")
                        .accessibilityHint("Enter latitude between negative 90 and positive 90")
                        .accessibilityValue(latitude.isEmpty ? "Empty" : latitude)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: latitude) { oldValue, newValue in
                            latitude = LocationValidation.sanitizeCoordinateInput(newValue)
                        }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Longitude")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    TextField("-180 to 180", text: $longitude)
                        .accessibilityLabel("Longitude")
                        .accessibilityHint("Enter longitude between negative 180 and positive 180")
                        .accessibilityValue(longitude.isEmpty ? "Empty" : longitude)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: longitude) { oldValue, newValue in
                            longitude = LocationValidation.sanitizeCoordinateInput(newValue)
                        }
                }
            }
            
            if let error = validationError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .accessibilityAddTraits(.isStaticText)
                    .accessibilityLabel("Validation error: \(error)")
            }
            
            Button {
                handleSubmit()
            } label: {
                Label("Open in Wikipedia", systemImage: "globe")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isInputValid)
            .accessibilityLabel("Open in Wikipedia")
            .accessibilityHint(isInputValid ? "Opens Wikipedia app with entered coordinates" : "Button disabled. Please enter valid coordinates")
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Private Methods
    private func handleSubmit() {
        validationError = nil
        
        guard let lat = LocationValidation.parseCoordinate(latitude),
              let lon = LocationValidation.parseCoordinate(longitude) else {
            validationError = "Please enter valid numbers"
            return
        }
        
        guard LocationValidation.isValidCoordinates(latitude: lat, longitude: lon) else {
            validationError = "Coordinates out of range"
            return
        }
        
        onSubmit(lat, lon)
    }
}

// MARK: - Preview
#Preview {
    CustomLocationInputView(
        name: .constant(""),
        latitude: .constant(""),
        longitude: .constant("")
    ) { lat, lon in
        print("Opening: \(lat), \(lon)")
    }
    .padding()
}
