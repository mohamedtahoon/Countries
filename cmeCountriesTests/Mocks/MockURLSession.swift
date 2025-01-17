//
//  MockURLSession.swift
//  cmeCountriesTests
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation
import XCTest
@testable import cmeCountries

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        guard let data = mockData, let response = mockResponse else {
            throw NetworkError.noData
        }
        return (data, response)
    }
}
