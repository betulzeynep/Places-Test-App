//
//  CustomLocationInputView.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import SwiftUI

// MARK: - Custom Location Input View
struct CustomLocationInputView: View {
    private enum SearchMode: String, CaseIterable, Identifiable {
        case byName = "By Name"
        case byCoordinates = "By Coordinates"

        var id: String { rawValue }
    }

    // MARK: - Bindings
    @Binding var name: String
    @Binding var latitude: String
    @Binding var longitude: String

    // MARK: - Properties
    let onSubmit: (Double?, Double?, String?) -> Void

    // MARK: - State
    @State private var searchMode: SearchMode = .byName
    @State private var validationError: String?

    // MARK: - Computed Properties

    /// Validates if input is valid for selected search mode.
    private var isInputValid: Bool {
        switch searchMode {
        case .byName:
            return !name.trimmingCharacters(in: .whitespaces).isEmpty
        case .byCoordinates:
            guard
                let lat = LocationValidation.parseCoordinate(latitude),
                let lon = LocationValidation.parseCoordinate(longitude)
            else {
                return false
            }
            return LocationValidation.isValidCoordinates(
                latitude: lat,
                longitude: lon
            )
        }
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.UI.largeSpacing) {
            Picker("Search Mode", selection: $searchMode) {
                ForEach(SearchMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .accessibilityLabel("Search mode")
            .onChange(of: searchMode) { _, newMode in
                validationError = nil
                switch newMode {
                case .byName:
                    latitude = ""
                    longitude = ""
                case .byCoordinates:
                    name = ""
                }
            }

            if searchMode == .byName {
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
                        .accessibilityLabel("Location name")
                        .accessibilityHint(
                            "Enter a location name to open its Wikipedia article"
                        )
                        .accessibilityIdentifier(
                            Constants.Accessibility.Identifiers
                                .customLocationNameField
                        )
                }
            } else {
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
                }
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
                .keyboardType(.numbersAndPunctuation)
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
        switch searchMode {
        case .byName:
            return "Opens Wikipedia article for location name"
        case .byCoordinates:
            return "Opens Wikipedia Places tab with coordinates"
        }
    }

    // MARK: - Private Methods
    private func handleSubmit() {
        validationError = nil

        switch searchMode {
        case .byName:
            let trimmedName = name.trimmingCharacters(in: .whitespaces)
            guard !trimmedName.isEmpty else {
                validationError = "Please provide a location name"
                Logger.ui("Name input empty for by-name mode", level: .warning)
                return
            }

            Logger.ui(
                "Submitting location name only: \(trimmedName)",
                level: .info
            )
            onSubmit(nil, nil, trimmedName)
        case .byCoordinates:
            guard
                let lat = LocationValidation.parseCoordinate(latitude),
                let lon = LocationValidation.parseCoordinate(longitude)
            else {
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
        }
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
