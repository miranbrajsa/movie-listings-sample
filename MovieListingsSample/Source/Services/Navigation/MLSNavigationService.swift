//
//  MLSNavigationService.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit

class MLSNavigationService: NavigationService {

    let window: UIWindow
    
    let apiService: MLSAPIService
    let plistReaderService: PlistReaderService

    var navigationController: UINavigationController?
    
    init(with window: UIWindow) {
        self.window = window
        
        self.plistReaderService = PlistReaderService()
        self.apiService = MLSAPIService(with: plistReaderService)
                
        displayMovieListingsViewController()
    }
}
