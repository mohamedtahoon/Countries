//
//  NetworkError.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case custom(String)

    var message: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received"
        case .decodingError: return "Error decoding data"
        case .serverError(let code): return "Server error: \(code)"
        case .custom(let message): return message
        }
    }

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL): return true
        case (.noData, .noData): return true
        case (.decodingError, .decodingError): return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)): return lhsCode == rhsCode
        case (.custom(let lhsMessage), .custom(let rhsMessage)): return lhsMessage == rhsMessage
        default: return false
        }
    }
}
