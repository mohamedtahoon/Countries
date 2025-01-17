//
//  CountryCoordinator.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation
import SwiftUI

class CountryCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    func pushDetail(_ country: Country) {
        path.append(country)
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
