//
//  MovieDetailsViewController+Delegates.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit

extension MovieDetailsViewController: MovieDetailsContentViewDelegate {
    
    var imagePath: String { viewModel.imagePath }
    var year: String { viewModel.year }
    var movieTitle: String { viewModel.title }
    var movieDescription: String { viewModel.description }
}
