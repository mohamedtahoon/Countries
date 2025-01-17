//
//  NetworkServiceTest.swift
//  cmeCountriesTests
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation
import XCTest
@testable import cmeCountries

class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        networkService = NetworkService(baseURL: "https://Tahoon.com", urlSession: mockURLSession)
    }
    
    override func tearDown() {
        networkService = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testFetchCountriesSuccess() async {
        let jsonData = """
        [{"name": "Egypt", "capital": "Cairo", "alpha2Code": "EG"}]
        """.data(using: .utf8)!
        mockURLSession.mockData = jsonData
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://Tahoon.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            let countries = try await networkService.fetchCountries()
            XCTAssertEqual(countries.count, 1)
            XCTAssertEqual(countries.first?.name, "Egypt")
        } catch {
            XCTFail("Fetching countries failed: \(error)")
        }
    }
    
    func testFetchCountriesFailure() async {
        mockURLSession.mockError = NetworkError.noData
        
        do {
            _ = try await networkService.fetchCountries()
            XCTFail("Expected fetchCountries to throw an error")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.noData)
        }
    }
}
