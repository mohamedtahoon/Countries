//
//  SavedCountriesView.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation
import SwiftUI

struct SavedCountriesView: View {
    @ObservedObject var viewModel: CountryViewModel

    var body: some View {
        List {
            ForEach(viewModel.savedCountries) { country in
                NavigationLink(destination: DetailView(country: country)) {
                    CountryCellView(country: country)
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    viewModel.removeCountry(viewModel.savedCountries[index])
                }
            }
        }
        .navigationTitle("Saved Countries")
    }
}
