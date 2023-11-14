//
//  MLSNavigationService+MovieListings.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit

extension MLSNavigationService: MovieListingsNavigationService {

    func displayMovieListingsViewController() {
        let viewController = MovieListingsViewController()
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
