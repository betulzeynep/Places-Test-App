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
    let onSubmit: (Double?, Double?, String?) -> Void

    // MARK: - State
    @State private var validationError: String?

    // MARK: - Computed Properties

    /// Validates if input is valid
    /// Either name OR coordinates should be provided
    private var isInputValid: Bool {
        let hasName = !name.trimmingCharacters(in: .whitespaces).isEmpty

        let latValue = LocationValidation.parseCoordinate(latitude)
        let lonValue = LocationValidation.parseCoordinate(longitude)
        let hasCoordinates =
            latValue != nil && lonValue != nil
            && LocationValidation.isValidCoordinates(
                latitude: latValue!,
                longitude: lonValue!
            )

        return hasName != hasCoordinates
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.UI.largeSpacing) {
            // Name Input
            VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                HStack {
                    Text("Location Name")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("search by name")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                TextField("e.g., Istanbul", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .disabled(!latitude.isEmpty || !longitude.isEmpty)
                    .opacity(
                        (!latitude.isEmpty || !longitude.isEmpty) ? 0.5 : 1.0
                    )
                    .accessibilityLabel("Location name")
                    .accessibilityHint(
                        "Enter a location name to open its Wikipedia article"
                    )
                    .accessibilityIdentifier(
                        Constants.Accessibility.Identifiers
                            .customLocationNameField
                    )
            }

            // Coordinates
            VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                HStack {
                    Text("Coordinates")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("search by coordinates")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                HStack(spacing: Constants.UI.mediumSpacing) {
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
                .disabled(!name.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(
                    !name.trimmingCharacters(in: .whitespaces).isEmpty
                        ? 0.5 : 1.0
                )
            }

            // Validation Error
            if let error = validationError {
                HStack(spacing: Constants.UI.smallSpacing) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                        .accessibilityHidden(true)
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
                .accessibilityAddTraits(.isStaticText)
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
                .clipShape(
                    RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                )
            }
            .buttonStyle(.plain)
            .disabled(!isInputValid)
            .accessibilityLabel("Open in Wikipedia")
            .accessibilityHint(submitButtonHint)
            .accessibilityIdentifier(
                Constants.Accessibility.Identifiers.openWikipediaButton
            )
        }
        .padding(.vertical, Constants.UI.smallSpacing)
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

    // MARK: - Computed Properties

    private var submitButtonHint: String {
        let hasName = !name.trimmingCharacters(in: .whitespaces).isEmpty
        let hasCoordinates = !latitude.isEmpty && !longitude.isEmpty

        if hasName && hasCoordinates {
            return "Opens Wikipedia Places tab with article and coordinates"
        } else if hasName {
            return "Opens Wikipedia article for location name"
        } else if hasCoordinates {
            return "Opens Wikipedia Places tab with coordinates"
        } else {
            return "Button disabled. Please enter location name or coordinates"
        }
    }

    // MARK: - Private Methods
    private func handleSubmit() {
        validationError = nil

        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let hasName = !trimmedName.isEmpty

        // Parse coordinates
        let parsedLat = LocationValidation.parseCoordinate(latitude)
        let parsedLon = LocationValidation.parseCoordinate(longitude)

        // Validate based on what's provided
        if hasName && parsedLat == nil && parsedLon == nil {
            // Only name - valid!
            Logger.ui(
                "Submitting location name only: \(trimmedName)",
                level: .info
            )
            onSubmit(nil, nil, trimmedName)
            return
        } else if !hasName && parsedLat != nil && parsedLon != nil {
            // Only coordinates - validate them
            guard let lat = parsedLat, let lon = parsedLon else {
                let error = ValidationError.invalidInput("coordinates")
                validationError = error.userMessage
                Logger.ui(error.technicalMessage, level: .warning)
                return
            }

            guard
                LocationValidation.isValidCoordinates(
                    latitude: lat,
                    longitude: lon
                )
            else {
                let error = ValidationError.coordinatesOutOfRange
                validationError = error.userMessage
                Logger.ui(error.technicalMessage, level: .warning)
                return
            }

            Logger.ui(
                "Submitting coordinates only: lat=\(lat), lon=\(lon)",
                level: .info
            )
            onSubmit(lat, lon, nil)
            return
        }

        // Invalid state
        validationError =
            "Please provide either a location name or valid coordinates"
        Logger.ui("Invalid input state", level: .warning)
    }
}

// MARK: - Preview
#Preview {
    CustomLocationInputView(
        name: .constant(""),
        latitude: .constant(""),
        longitude: .constant("")
    ) { lat, lon, name in
        print(
            "Opening: lat=\(lat?.description ?? "nil"), lon=\(lon?.description ?? "nil"), name=\(name ?? "nil")"
        )
    }
    .padding()
}
