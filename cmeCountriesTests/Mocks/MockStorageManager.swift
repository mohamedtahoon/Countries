//
//  MockStorageManager.swift
//  cmeCountriesTests
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation
import XCTest
@testable import cmeCountries

class MockStorageManager: CountryStorageProtocol {
    var savedCountries: [Country] = []

    func saveCountries(_ countries: [Country]) throws {
        savedCountries.append(contentsOf: countries)
    }

    func fetchSavedCountries() throws -> [Country] {
        return savedCountries
    }

    func deleteCountry(_ country: Country) throws {
        savedCountries.removeAll { $0.name == country.name }
    }

    func deleteAllCountries() throws {
        savedCountries.removeAll()
    }
}
