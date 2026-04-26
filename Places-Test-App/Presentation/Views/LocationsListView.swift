//
//  LocationsListView.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import SwiftUI

// wikipedia://places?lat=41.0082&lon=28.9784
// wikipedia://places?lat=41.0082&lon=28.9784&WMFArticleURL=https://en.wikipedia.org/wiki/Istanbul

// MARK: - View
struct LocationsListView: View {
    @StateObject private var viewModel = LocationsViewModel()
    @State private var customLocationName = ""
    @State private var customLat = ""
    @State private var customLon = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Locations") {
                    ForEach(viewModel.locations) { location in
                        Button(location.name) {
                            openWikipedia(lat: location.lat, lon: location.lon)
                        }
                    }
                }
                
                Section("Custom Location") {
                    TextField("Name", text: $customLocationName)
                    TextField("Latitude", text: $customLat)
                        .keyboardType(.decimalPad)
                    TextField("Longitude", text: $customLon)
                        .keyboardType(.decimalPad)
                    
                    Button("Open in Wikipedia") {
                        if let lat = Double(customLat), let lon = Double(customLon) {
                            openWikipedia(lat: lat, lon: lon)
                        }
                    }
                }
            }
            .navigationTitle("Places")
        }
        .task {
            await viewModel.fetchLocations()
        }
    }
    
    func openWikipedia(lat: Double, lon: Double) {
        let urlString = "wikipedia://places?lat=\(lat)&lon=\(lon)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    LocationsListView()
}
