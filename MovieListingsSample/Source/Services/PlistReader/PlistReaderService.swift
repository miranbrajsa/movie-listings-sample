//
//  PlistReaderService.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Foundation

class PlistReaderService {

    enum Item: String {
        case tmdbApiKey = "tmdbAPIKey"
    }
    
    private var bundle: Bundle { Bundle.main }
    
    func read(_ item: Item) -> String {
        switch item {
        case .tmdbApiKey:
            guard let secretsPlistData = loadFromSecretsPlist() else {
                fatalError("Property list is unreadable")
            }
            return secretsPlistData.tmdbAPIKey
        }
    }

    private func loadFromSecretsPlist() -> SecretsData? {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let plistData = FileManager.default.contents(atPath: path)
        else { return nil }

        do {
            let decodedData = try PropertyListDecoder().decode(SecretsData.self, from: plistData)
            return decodedData
        } catch {
            print("Error reading plist: \(error)")
            return nil
        }
    }
}
