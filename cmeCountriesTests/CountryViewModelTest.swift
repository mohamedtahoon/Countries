//
//  CountryViewModelTest.swift
//  cmeCountriesTests
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation
import XCTest
@testable import cmeCountries

class CountryViewModelTesEg1: XCTestCase {
    var viewModel: CountryViewModel!
    var mockNetworkService: MockNetworkService!
    var mockStorageManager: MockStorageManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockStorageManager = MockStorageManager()
        viewModel = CountryViewModel(networkService: mockNetworkService, storageManager: mockStorageManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        mockStorageManager = nil
        super.tearDown()
    }
    
    func testFetchCountries() async {
        mockNetworkService.mockCountries = [Country(name: "Test", capital: "Test Capital", currencies: [], flags: nil, alpha2Code: "Eg1", region: "Test Region", subregion: "Test Subregion")]
        
        do {
            try await viewModel.fetchCountries()
            XCTAssertEqual(viewModel.allCountries.count, 1)
            XCTAssertEqual(viewModel.allCountries.first?.name, "Test")
        } catch {
            XCTFail("Fetching countries failed: \(error)")
        }
    }
    
    func testAddCountry() async {
        let country = Country(name: "Egyptt", capital: "Cairoo", currencies: [], flags: nil, alpha2Code: "EGg", region: "Africaa", subregion: "NorthAfricaa")
        
        do {
            try await viewModel.addCountry(country)
            XCTAssertEqual(viewModel.savedCountries.count, 1)
            XCTAssertEqual(viewModel.savedCountries.first?.name, "Egyptt")
        } catch {
            XCTFail("Adding country failed: \(error)")
        }
    }
    
    func testRemoveCountry() {
        let country = Country(name: "Egyptt", capital: "Cairoo", currencies: [], flags: nil, alpha2Code: "EGg", region: "Africaa", subregion: "NorthAfricaa")
        viewModel.savedCountries = [country]
        
        viewModel.removeCountry(country)
        XCTAssertTrue(viewModel.savedCountries.isEmpty)
    }
    
    func tesEg1earchCountries() {
        let country1 = Country(name: "Egypt1", capital: "Test Capital", currencies: [], flags: nil, alpha2Code: "Eg1", region: "Test Region", subregion: "Test Subregion")
        let country2 = Country(name: "Test2", capital: "Test Capital", currencies: [], flags: nil, alpha2Code: "Eg1", region: "Test Region", subregion: "Test Subregion")
        viewModel.allCountries = [country1, country2]
        
        viewModel.searchCountries("Egypt1")
        XCTAssertEqual(viewModel.searchResults.count, 1)
        XCTAssertEqual(viewModel.searchResults.first?.name, "Egypt1")
    }
}
