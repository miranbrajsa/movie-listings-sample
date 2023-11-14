//
//  NavigationService.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Foundation

protocol NavigationService: AnyObject {}

protocol MovieListingsNavigationService: NavigationService {
    func displayMovieListingsViewController()
}
