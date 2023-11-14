//
//  MLSNavigationService.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit

class MLSNavigationService: NavigationService {

    let window: UIWindow

    init(with window: UIWindow) {
        self.window = window
        
        displayMovieListingsViewController()
    }
}
