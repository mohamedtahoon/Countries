//
//  MockNetworkService.swift
//  cmeCountriesTests
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation
import XCTest
@testable import cmeCountries

class MockNetworkService: NetworkServiceProtocol {
    var mockCountries: [Country] = []

    func fetchCountries() async throws -> [Country] {
        return mockCountries
    }
}
