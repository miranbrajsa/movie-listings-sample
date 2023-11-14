//
//  MovieListingsViewController.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Combine
import UIKit

class MovieListingsViewModel {

    private weak var apiService: APIService?
    private weak var movieListingsAPIService: MovieListingsAPIService? { apiService as? MovieListingsAPIService }

    private weak var navigationService: NavigationService?

    private var cancellables = Set<AnyCancellable>()

    init(with navigationService: NavigationService?, apiService: APIService) {
        self.navigationService = navigationService
        self.apiService = apiService

        attachObservers()
    }

    func refreshMovieListings() {
        movieListingsAPIService?
            .getTrendingMoviesList()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("An error occurred during API call: \(error)")
                }
            }, receiveValue: { movieListings in
                print("aaa")
            })
            .store(in: &cancellables)
    }
    
    private func attachObservers() {
        refreshMovieListings()
    }
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
