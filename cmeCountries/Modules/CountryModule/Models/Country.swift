//
//  Country.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 16/01/2025.
//

import Foundation

struct Country: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: String
    let capital: String?
    let currencies: [Currency]?
    let flags: Flags?
    let alpha2Code: String
    let region: String?
    let subregion: String?
    
    enum CodingKeys: String, CodingKey {
        case name, capital, currencies, flags, alpha2Code, region, subregion
    }
}

struct Flags: Codable, Hashable {
    let svg: String?
    let png: String?
}

struct Currency: Codable, Hashable, Identifiable {
    var id: String { code ?? UUID().uuidString }
    let code: String?
    let name: String?
    let symbol: String?
}
