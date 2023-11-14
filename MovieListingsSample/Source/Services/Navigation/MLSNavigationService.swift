//
//  MLSNavigationService.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit

class MLSNavigationService: NavigationService {

    let window: UIWindow
    
    let plistReaderService: PlistReaderService

    init(with window: UIWindow) {
        self.window = window
        
        self.plistReaderService = PlistReaderService()
        
        displayMovieListingsViewController()
    }
}
