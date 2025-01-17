//
//  CountryViewError.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation

enum CountryViewError: LocalizedError {
    case maxCountriesReached
    case countryAlreadyAdded
    case locationError
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .maxCountriesReached:
            return "Maximum of 5 countries reached. Please remove a country to add a new one."
        case .countryAlreadyAdded:
            return "This country is already in your list."
        case .locationError:
            return "Unable to determine your location. Using Egypt as default."
        case .networkError(let message):
            return message
        }
    }
}
