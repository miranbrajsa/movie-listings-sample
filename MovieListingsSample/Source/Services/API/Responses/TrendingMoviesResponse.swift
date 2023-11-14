//
//  TrendingMoviesResponse.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Foundation

struct TrendingMoviesResponse: Codable {
    struct Movie: Codable {
        let id: Int
        let title: String
        
        let posterPath: String
        let releaseDate: String
        
        let popularity: Double
    }
    
    let page: Int
    let totalPages: Int
    
    let results: [Movie]
}
