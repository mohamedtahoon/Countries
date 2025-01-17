//
//  SearchView.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 16/01/2025.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: CountryViewModel
    @State private var searchText = ""
    @State private var showAddSuccessAlert = false

    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(searchText.isEmpty ? viewModel.allCountries : viewModel.searchResults) { country in
                    ZStack {
                        Button {
                            Task {
                                do {
                                    try await viewModel.addCountry(country)
                                    showAddSuccessAlert = true
                                }
                            }
                        } label: {
                            CountryCellView(country: country)
                        }

                    }
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: searchText) { query in
            viewModel.searchCountries(query)
        }
        .navigationTitle("Search Countries")
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchCountries()
                } catch {
                    viewModel.error = .networkError(error.localizedDescription)
                    viewModel.showError = true
                }
            }
        }
        .alert("Success", isPresented: $showAddSuccessAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("The country has been added to your saved list.")
        }
    }
}
