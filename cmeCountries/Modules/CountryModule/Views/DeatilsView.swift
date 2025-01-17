//
//  DeatilsView.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 16/01/2025.
//

import Foundation
import SwiftUI

struct DetailView: View {
    let country: Country
    @StateObject private var imageLoader: ImageLoader
    
    init(country: Country) {
        self.country = country
        let pngUrl = country.flags?.png.flatMap(URL.init)
        self._imageLoader = StateObject(wrappedValue: ImageLoader(url: pngUrl))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                }
                
                VStack(spacing: 16) {
                    CountryInfoCard(title: "Region", value: country.region ?? "N/A")
                    CountryInfoCard(title: "Subregion", value: country.subregion ?? "N/A")
                    CountryInfoCard(title: "Capital", value: country.capital ?? "N/A")
                    
                    if let currencies = country.currencies, !currencies.isEmpty {
                        let currencyInfo = currencies.map { currency in
                            "\(currency.name ?? "") (\(currency.symbol ?? ""))"
                        }.joined(separator: ", ")
                        CountryInfoCard(title: "Currency", value: currencyInfo)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(country.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

