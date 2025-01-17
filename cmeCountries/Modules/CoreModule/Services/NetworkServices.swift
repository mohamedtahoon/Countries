//
//  NetworkServices.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 16/01/2025.
//

import Foundation


protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

protocol NetworkServiceProtocol {
    func fetchCountries() async throws -> [Country]
}

extension URLSession: URLSessionProtocol {}

class NetworkService: NetworkServiceProtocol {
    private let baseURL: String
    private let urlSession: URLSessionProtocol

    init(baseURL: String = "https://restcountries.com/v2/all", urlSession: URLSessionProtocol = URLSession.shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }

    func fetchCountries() async throws -> [Country] {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        let (data, response) = try await urlSession.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError((response as? HTTPURLResponse)?.statusCode ?? 500)
        }
        return try JSONDecoder().decode([Country].self, from: data)
    }
}
