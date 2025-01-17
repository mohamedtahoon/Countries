//
//  MainView.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation
import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = CountryViewModel()

    var body: some View {
        TabView {
            NavigationView {
                SavedCountriesView(viewModel: viewModel)
            }
            .tabItem {
                Label("Saved", systemImage: "star.fill")
            }

            NavigationView {
                SearchView(viewModel: viewModel)
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
        }
        .alert("Error", isPresented: $viewModel.showError, presenting: viewModel.error) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            Text(error.errorDescription ?? "Unknown error occurred")
        }
    }
}
