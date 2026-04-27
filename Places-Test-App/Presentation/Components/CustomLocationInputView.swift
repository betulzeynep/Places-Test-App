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
            let lon = LocationValidation.parseCoordinate(longitude)
        else {
            return false
        }
        return LocationValidation.isValidCoordinates(
            latitude: lat,
            longitude: lon
        )
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.UI.largeSpacing) {
            // Name Input
            VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                Label("Location Name", systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                TextField("Optional", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("Location name")
            }

            // Coordinates
            VStack(alignment: .leading, spacing: 8) {
                Label("Coordinates", systemImage: "location.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    coordinateInput(
                        title: "Latitude",
                        placeholder: "-90 to 90",
                        text: $latitude
                    )

                    coordinateInput(
                        title: "Longitude",
                        placeholder: "-180 to 180",
                        text: $longitude
                    )
                }
            }

            // Validation Error
            if let error = validationError {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
                .accessibilityLabel("Validation error: \(error)")
            }

            // Submit Button
            Button {
                handleSubmit()
            } label: {
                HStack {
                    Image(systemName: "globe")
                    Text("Open in Wikipedia")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isInputValid ? Color.accentColor : Color.gray)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!isInputValid)
        }
    }

    @ViewBuilder
    private func coordinateInput(
        title: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            TextField(placeholder, text: text)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .accessibilityLabel(title)
                .accessibilityHint(
                    "Enter \(title.lowercased()) between \(placeholder)"
                )
                .accessibilityValue(
                    text.wrappedValue.isEmpty
                        ? Constants.Defaults.emptyFieldValue : text.wrappedValue
                )
                .accessibilityIdentifier(
                    title == "Latitude"
                        ? Constants.Accessibility.Identifiers.latitudeField
                        : Constants.Accessibility.Identifiers.longitudeField
                )
                .onChange(of: text.wrappedValue) { _, newValue in
                    text.wrappedValue =
                        LocationValidation.sanitizeCoordinateInput(newValue)
                }
        }
    }

    // MARK: - Private Methods
    private func handleSubmit() {
        validationError = nil

        guard let lat = LocationValidation.parseCoordinate(latitude),
            let lon = LocationValidation.parseCoordinate(longitude)
        else {
            let error = ValidationError.invalidInput("coordinates")
            validationError = error.userMessage
            Logger.ui(error.technicalMessage, level: .warning)
            return
        }

        guard
            LocationValidation.isValidCoordinates(latitude: lat, longitude: lon)
        else {
            let error = ValidationError.coordinatesOutOfRange
            validationError = error.userMessage
            Logger.ui(error.technicalMessage, level: .warning)
            return
        }

        Logger.ui(
            "Submitting valid coordinates: lat=\(lat), lon=\(lon)",
            level: .info
        )
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
