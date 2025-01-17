//
//  CoordinatorView.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation
import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = CountryCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MainView()
                .navigationDestination(for: Country.self) { country in
                    DetailView(country: country)
                }
        }
        .environmentObject(coordinator)
    }
}
