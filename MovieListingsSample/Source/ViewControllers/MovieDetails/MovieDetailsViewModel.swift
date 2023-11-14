//
//  MovieDetailsViewModel.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Foundation

class MovieDetailsViewModel {

    private let details: TrendingMoviesResponse.Movie
    private let configuration: ConfigurationResponse
    
    private let dateFormatter: DateFormatter

    var year: String {
        let date = dateFormatter.date(from: details.releaseDate)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date ?? Date())
        return "\(year)"
    }
    
    var title: String { details.title }
    var description: String { details.overview }
    var imagePath: String { ImagePathConstructor.constructFullImagePath(given: configuration, imagePath: details.posterPath) }

    init(with details: TrendingMoviesResponse.Movie, configuration: ConfigurationResponse) {
        self.details = details
        self.configuration = configuration
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }
}
