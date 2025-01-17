//
//  CoreDataManager.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 16/01/2025.
//

import Foundation
import CoreData

class CoreDataManager: CountryStorageProtocol {
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
    }
    
    func saveCountries(_ countries: [Country]) throws {
        for country in countries {
            let savedCountry = SavedCountry(context: viewContext)
            savedCountry.id = country.id
            savedCountry.name = country.name
            savedCountry.capital = country.capital
            savedCountry.flag = country.flags?.png
            savedCountry.alpha2Code = country.alpha2Code
            savedCountry.region = country.region
            savedCountry.subregion = country.subregion
            
            if let firstCurrency = country.currencies?.first {
                savedCountry.currencyCode = firstCurrency.code
                savedCountry.currencyName = firstCurrency.name
                savedCountry.currencySymbol = firstCurrency.symbol
            }
        }
        
        try viewContext.save()
    }
    
    func fetchSavedCountries() throws -> [Country] {
        let fetchRequest: NSFetchRequest<SavedCountry> = SavedCountry.fetchRequest()
        let savedCountries = try viewContext.fetch(fetchRequest)
        
        return savedCountries.map { savedCountry in
            let currency = Currency(
                code: savedCountry.currencyCode,
                name: savedCountry.currencyName,
                symbol: savedCountry.currencySymbol
            )
            
            let flags = Flags(
                svg: "",
                png: savedCountry.flag
            )
            
            return Country(
                name: savedCountry.name ?? "",
                capital: savedCountry.capital,
                currencies: currency.code != nil ? [currency] : [],
                flags: flags,
                alpha2Code: savedCountry.alpha2Code ?? "",
                region: savedCountry.region,
                subregion: savedCountry.subregion
                
            )
        }
    }
    
    func deleteCountry(_ country: Country) throws {
        let fetchRequest: NSFetchRequest<SavedCountry> = SavedCountry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", country.name)
        
        let countries = try viewContext.fetch(fetchRequest)
        countries.forEach { viewContext.delete($0) }
        
        try viewContext.save()
    }
    
    func deleteAllCountries() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SavedCountry.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try viewContext.execute(deleteRequest)
        try viewContext.save()
    }
}
