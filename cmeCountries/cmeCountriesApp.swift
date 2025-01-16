//
//  cmeCountriesApp.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 16/01/2025.
//

import SwiftUI

@main
struct cmeCountriesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
