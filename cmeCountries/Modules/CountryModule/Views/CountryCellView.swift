//
//  CountryCellView.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation
import SwiftUI

struct CountryCellView: View {
    let country: Country
    @StateObject private var imageLoader: ImageLoader

    init(country: Country) {
        self.country = country
        let pngUrl = country.flags?.png.flatMap(URL.init)
        self._imageLoader = StateObject(wrappedValue: ImageLoader(url: pngUrl))
    }

    var body: some View {
        HStack(spacing: 12) {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 30)
                    .cornerRadius(4)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 30)
                    .cornerRadius(4)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(country.name)
                    .font(.headline)
                
                HStack {
                    if let capital = country.capital {
                        Text(capital)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                if let currencies = country.currencies, !currencies.isEmpty {
                    HStack {
                        ForEach(currencies, id: \.code) { currency in
                            if let symbol = currency.symbol, let code = currency.code {
                                Text("\(symbol) \(code)")
                                    .font(.caption)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
