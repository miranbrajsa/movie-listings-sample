//
//  MLSNavigationService+MovieListings.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit

extension MLSNavigationService: MovieListingsNavigationService {

    func displayMovieListingsViewController() {
        let viewModel = MovieListingsViewModel()
        let viewController = MovieListingsViewController(with: viewModel)
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
