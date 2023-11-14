//
//  MLSNavigationService+MovieListings.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit

extension MLSNavigationService: MovieListingsNavigationService {

    func displayMovieListingsViewController() {
        let viewModel = MovieListingsViewModel(with: self, apiService: apiService)
        let viewController = MovieListingsViewController(with: viewModel)
        
        navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
