//
//  LocationsViewModel.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import Combine

// MARK: - ViewModel
@MainActor
class LocationsViewModel: ObservableObject {
    @Published var locations: [Location] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchLocations() async {
        // Fetch from JSON URL
        // ...
    }
}
