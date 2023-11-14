//
//  MovieListingsCellViewModel.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Foundation

class MovieListingsCellViewModel {
    
    let movieResponse: TrendingMoviesResponse.Movie
    
    private var configuration: ConfigurationResponse?
    
    var title: String { movieResponse.title }
    
    var imagePath: String {
        guard let configuration = configuration else { return "" }
        
        return ImagePathConstructor.constructFullImagePath(given: configuration, imagePath: movieResponse.posterPath)
    }
    
    init(with movieResponse: TrendingMoviesResponse.Movie, configuration: ConfigurationResponse?) {
        self.movieResponse = movieResponse
        self.configuration = configuration
    }
}
