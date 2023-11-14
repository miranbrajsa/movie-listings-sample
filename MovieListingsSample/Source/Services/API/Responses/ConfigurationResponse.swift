//
//  ConfigurationResponse.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Foundation

struct ConfigurationResponse: Decodable {
    struct Image: Decodable {
        let secureBaseUrl: String
        let posterSizes: [String]
    }
    
    let images: Image
}
