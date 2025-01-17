//
//  CountryStorageProtocol.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation

protocol CountryStorageProtocol {
    func saveCountries(_ countries: [Country]) throws
    func fetchSavedCountries() throws -> [Country]
    func deleteCountry(_ country: Country) throws
    func deleteAllCountries() throws
}
