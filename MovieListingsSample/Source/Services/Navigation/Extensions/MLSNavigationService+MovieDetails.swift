//
//  MLSNavigationService+MovieDetails.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit

extension MLSNavigationService: MovieDetailsNavigationService {

    func pushMovieDetailsViewController(with details: TrendingMoviesResponse.Movie, configuration: ConfigurationResponse) {
        let viewModel = MovieDetailsViewModel(with: details, configuration: configuration)
        let viewController = MovieDetailsViewController(with: viewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
