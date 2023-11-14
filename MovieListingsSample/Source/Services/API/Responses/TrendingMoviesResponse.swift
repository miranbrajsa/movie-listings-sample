//
//  TrendingMoviesResponse.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Foundation

struct TrendingMoviesResponse: Decodable {
    struct Movie: Decodable {
        let id: Int
        
        let title: String
        let overview: String
        
        let posterPath: String
        let releaseDate: String
        
        let popularity: Double
    }
    
    let page: Int
    let totalPages: Int
    
    let results: [Movie]
}
