//
//  CountryViewModel.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 16/01/2025.
//

import Foundation
import CoreLocation
import Combine

class CountryViewModel: NSObject, ObservableObject {
    @Published var savedCountries: [Country] = []
    @Published var allCountries: [Country] = []
    @Published var searchResults: [Country] = []
    @Published var isLoading = false
    @Published var error: CountryViewError?
    @Published var showError = false
    
    private let networkService: NetworkServiceProtocol
    private let storageManager: CountryStorageProtocol
    private let locationManager: CLLocationManager
    private var cancellables = Set<AnyCancellable>()
    
    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        storageManager: CountryStorageProtocol = CoreDataManager(),
        locationManager: CLLocationManager = CLLocationManager()
    ) {
        self.networkService = networkService
        self.storageManager = storageManager
        self.locationManager = locationManager
        super.init()
        setupLocationManager()
        loadSavedCountries()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
    }
    
    func loadSavedCountries() {
        do {
            savedCountries = try storageManager.fetchSavedCountries()
            
            // Move the default country (Egypt) to the top if it exists
            if let egyptIndex = savedCountries.firstIndex(where: { $0.name == "Egypt" }) {
                let egypt = savedCountries.remove(at: egyptIndex)
                savedCountries.insert(egypt, at: 0)
            }
            
            // If no countries are saved, add the default country
            if savedCountries.isEmpty {
                addDefaultCountry()
            }
        } catch {
            self.error = .networkError(error.localizedDescription)
            self.showError = true
        }
    }
    
    private func addDefaultCountry() {
        Task {
            do {
                let countries = try await networkService.fetchCountries()
                if let egypt = countries.first(where: { $0.name == "Egypt" }) {
                    try await addCountry(egypt)
                }
            } catch {
                self.error = .networkError(error.localizedDescription)
                self.showError = true
            }
        }
    }
    
    func fetchCountries() async throws -> [Country] {
        let countries = try await networkService.fetchCountries()
        await MainActor.run {
            self.allCountries = countries
        }
        return countries
    }
    
    func searchCountries(_ query: String) {
        guard !query.isEmpty else {
            searchResults = allCountries
            return
        }
        
        searchResults = allCountries.filter {
            $0.name.lowercased().hasPrefix(query.lowercased())
        }
    }
    
    func addCountry(_ country: Country) async throws {
        await MainActor.run {
            // Check for duplicates first
            if savedCountries.contains(where: { $0.name == country.name }) {
                error = .countryAlreadyAdded
                showError = true
                return
            }
            
            // Then check for maximum limit
            if savedCountries.count >= 5 {
                error = .maxCountriesReached
                showError = true
                return
            }
            
            // Only proceed if both checks pass
            Task {
                do {
                    try storageManager.saveCountries([country])
                    savedCountries.append(country)
                    
                    // Ensure the default country (Egypt) is at the top
                    if let egyptIndex = savedCountries.firstIndex(where: { $0.name == "Egypt" }) {
                        let egypt = savedCountries.remove(at: egyptIndex)
                        savedCountries.insert(egypt, at: 0)
                    }
                } catch {
                    self.error = .networkError(error.localizedDescription)
                    self.showError = true
                }
            }
        }
    }
    
    func removeCountry(_ country: Country) {
        do {
            try storageManager.deleteCountry(country)
            savedCountries.removeAll { $0.name == country.name }
            
            // Ensure the default country (Egypt) is at the top
            if let egyptIndex = savedCountries.firstIndex(where: { $0.name == "Egypt" }) {
                let egypt = savedCountries.remove(at: egyptIndex)
                savedCountries.insert(egypt, at: 0)
            }
        } catch {
            self.error = .networkError(error.localizedDescription)
            self.showError = true
        }
    }
    
}

// MARK: - CLLocationManagerDelegate
extension CountryViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            addDefaultCountry()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first,
              savedCountries.isEmpty else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self,
                  let countryCode = placemarks?.first?.isoCountryCode else {
                self?.addDefaultCountry()
                return
            }
            
            Task {
                do {
                    let countries = try await self.networkService.fetchCountries()
                    if let userCountry = countries.first(where: { $0.alpha2Code == countryCode }) {
                        try await self.addCountry(userCountry)
                    }
                } catch {
                    await MainActor.run {
                        self.error = .networkError(error.localizedDescription)
                        self.showError = true
                    }
                }
            }
        }
    }
}
