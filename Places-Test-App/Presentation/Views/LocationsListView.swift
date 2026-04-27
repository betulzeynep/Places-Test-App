//
//  LocationsListView.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import SwiftUI

// wikipedia://places?lat=41.0082&lon=28.9784
// wikipedia://places?lat=41.0082&lon=28.9784&WMFArticleURL=https://en.wikipedia.org/wiki/Istanbul

// MARK: - LocationsList View
struct LocationsListView: View {

    // MARK: - State
    @StateObject private var viewModel = DependencyContainer.shared
        .makeLocationsViewModel()
    @State private var customLocationName = ""
    @State private var customLat = ""
    @State private var customLon = ""

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                mainContent

                if viewModel.isLoading {
                    loadingOverlay
                }
            }
            .navigationTitle("Places")
            .accessibilityLabel(
                "Places: \(viewModel.locations.count) locations available"
            )
            .overlay(alignment: .top) {
                if let errorMessage = viewModel.errorMessage {
                    ErrorView(
                        message: errorMessage,
                        onDismiss: viewModel.clearError
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(), value: viewModel.errorMessage)
                    .padding(.top)
                }
            }
        }
        .task {
            await viewModel.fetchLocations()
        }
    }

    // MARK: - View Components

    private var mainContent: some View {
        List {
            // Locations Section
            if viewModel.locations.isEmpty && !viewModel.isLoading {
                emptyStateSection
            } else if !viewModel.locations.isEmpty {
                locationsSection
            }

            // Custom Location Section
            customLocationSection
        }
        .listStyle(.insetGrouped)
        .refreshable {
            await viewModel.fetchLocations()
        }
    }

    // MARK: - Sections

    private var locationsSection: some View {
        Section {
            ForEach(viewModel.locations) { location in
                Button {
                    Logger.ui(
                        "User tapped location: \(location.name)",
                        level: .info
                    )
                    viewModel.openLocation(location)
                } label: {
                    LocationRow(location: location)
                }
                .buttonStyle(.plain)
            }
        } header: {
            HStack {
                Image(systemName: "map.fill")
                    .accessibilityHidden(true)
                Text(Constants.UIText.locationsHeaderTitle)
            }
            .font(.headline)
            .foregroundStyle(.primary)
            .textCase(nil)
            .accessibilityAddTraits(.isHeader)
        } footer: {
            HStack(spacing: Constants.UI.smallSpacing) {
                Image(systemName: "info.circle.fill")
                    .accessibilityHidden(true)
                Text(Constants.UIText.locationsCount(viewModel.locations.count))
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .accessibilityLabel(
                Constants.UIText.locationsCount(viewModel.locations.count)
            )
        }
    }

    private var customLocationSection: some View {
        Section {
            CustomLocationInputView(
                name: $customLocationName,
                latitude: $customLat,
                longitude: $customLon
            ) { lat, lon in
                Logger.ui(
                    "User submitted custom location: lat=\(lat), lon=\(lon)",
                    level: .info
                )
                viewModel.openCustomLocation(latitude: lat, longitude: lon)
            }
        } header: {
            HStack {
                Image(systemName: "location.fill.viewfinder")
                    .accessibilityHidden(true)
                Text(Constants.UIText.customLocationHeaderTitle)
            }
            .font(.headline)
            .foregroundStyle(.primary)
            .textCase(nil)
            .accessibilityAddTraits(.isHeader)
        } footer: {
            HStack(spacing: 4) {
                Image(systemName: "info.circle.fill")
                    .accessibilityHidden(true)
                Text(Constants.UIText.customLocationFooter)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }

    private var emptyStateSection: some View {
        Section {
            VStack(spacing: Constants.UI.largeSpacing) {
                Image(systemName: "map")
                    .font(.system(size: Constants.UI.emptyStateIconSize))
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)

                VStack(spacing: 8) {
                    Text(Constants.UIText.noLocationsTitle)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(Constants.UIText.noLocationsMessage)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Constants.UI.extraExtraLargeSpacing)
            .listRowBackground(Color.clear)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(
                Constants.Accessibility.Messages.emptyStateMessage
            )
            .accessibilityAddTraits(.isStaticText)
            .onAppear {
                Logger.ui("Empty state displayed", level: .info)
            }
        }
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(Constants.UI.errorOverlayOpacity)
                .ignoresSafeArea()
                .accessibilityHidden(true)  // Background is decorative

            VStack(spacing: Constants.UI.largeSpacing) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(Constants.UI.loadingScaleEffect)

                Text(Constants.UIText.loadingMessage)
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
            .padding(Constants.UI.extraLargeSpacing)
            .background(
                RoundedRectangle(cornerRadius: Constants.UI.largeCornerRadius)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: Constants.UI.largeShadowRadius)
            )
            .accessibilityElement(children: .combine)
            .accessibilityLabel(
                Constants.Accessibility.Messages.loadingLocations
            )
            .accessibilityAddTraits(.updatesFrequently)
            .onAppear {
                Logger.ui("Loading overlay displayed", level: .info)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    LocationsListView()
}
