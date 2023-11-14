//
//  MovieListingsViewController.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit

class MovieListingsViewModel {
    
}

class MovieListingsViewController: UIViewController {
    
    private let viewModel: MovieListingsViewModel

    init(with viewModel: MovieListingsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
