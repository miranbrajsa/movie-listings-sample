//
//  MovieListingsCellViewModel.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Foundation

class MovieListingsCellViewModel {
    
    private struct Constants {
        static let imageSize500px = "w500"
        static let imageSizeOriginal = "original"
    }

    private let movieResponse: TrendingMoviesResponse.Movie
    
    private var configuration: ConfigurationResponse?
    
    var title: String { movieResponse.title }
    
    var imagePath: String {
        guard let configuration = configuration else { return "" }
        
        let imageSize = configuration.images.posterSizes.first(where: { $0 == Constants.imageSize500px }) ?? Constants.imageSizeOriginal
        return "\(configuration.images.secureBaseUrl)\(imageSize)/\(movieResponse.posterPath)"
    }
    
    init(with movieResponse: TrendingMoviesResponse.Movie, configuration: ConfigurationResponse?) {
        self.movieResponse = movieResponse
        self.configuration = configuration
    }
}
