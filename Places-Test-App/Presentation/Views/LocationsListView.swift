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
    @StateObject private var viewModel = DependencyContainer.shared.makeLocationsViewModel()
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
            .accessibilityLabel("Places. \(viewModel.locations.count) locations available")
            .overlay(alignment: .top) {
                if let errorMessage = viewModel.errorMessage {
                    ErrorView(
                        message: errorMessage,
                        onDismiss: viewModel.clearError
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(), value: viewModel.errorMessage)
                    .padding(.top, 8)
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
            if !viewModel.locations.isEmpty {
                Section {
                    ForEach(viewModel.locations) { location in
                        Button {
                            viewModel.openLocation(location)
                        } label: {
                            LocationRow(location: location)
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Text("Locations")
                } footer: {
                    Text("\(viewModel.locations.count) location(s) available")
                        .font(.caption)
                }
            }
            
            // Custom Location Section
            Section {
                CustomLocationInputView(
                    name: $customLocationName,
                    latitude: $customLat,
                    longitude: $customLon
                ) { lat, lon in
                    viewModel.openCustomLocation(latitude: lat, longitude: lon)
                }
            } header: {
                Text("Custom Location")
            } footer: {
                Text("Enter coordinates to open any location in Wikipedia")
                    .font(.caption)
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            await viewModel.fetchLocations()
        }
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
                .accessibilityHidden(true)  // Background is decorative
            
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.white)
                .scaleEffect(1.5)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.regularMaterial)
                )
                .accessibilityLabel("Loading locations")
                .accessibilityAddTraits(.updatesFrequently)
        }
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Preview
#Preview {
    LocationsListView()
}
