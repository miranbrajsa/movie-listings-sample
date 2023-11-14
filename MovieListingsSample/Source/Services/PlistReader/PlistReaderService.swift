//
//  PlistReaderService.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Foundation

class PlistReaderService {

    enum Item: String {
        case tmdbApiKey = "api_key"
    }
    
    private var bundle: Bundle { Bundle.main }
    
    func read(_ item: Item) -> String {
        guard let value = bundle.object(forInfoDictionaryKey: item.rawValue) as? String else {
            fatalError("Unexisting value")
        }
        return value
    }
}
