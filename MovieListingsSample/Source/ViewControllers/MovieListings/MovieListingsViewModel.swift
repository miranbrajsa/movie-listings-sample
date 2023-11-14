//
//  MovieListingsViewModel.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Combine
import Foundation

class MovieListingsViewModel {

    private weak var apiService: APIService?
    private weak var configurationAPIService: ConfigurationAPIService? { apiService as? ConfigurationAPIService }
    private weak var movieListingsAPIService: MovieListingsAPIService? { apiService as? MovieListingsAPIService }

    private weak var navigationService: NavigationService?
    private weak var movieDetailsNavigationService: MovieDetailsNavigationService? { navigationService as? MovieDetailsNavigationService }

    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    private var totalPages = 1
    
    private var hasMoreResults: Bool { totalPages < currentPage }
    
    private(set) var configuration: ConfigurationResponse?
    private(set) var cellViewModels: [MovieListingsCellViewModel] = []

    @Published private(set) var isLoadingInProgress = false
    
    init(with navigationService: NavigationService?, apiService: APIService) {
        self.navigationService = navigationService
        self.apiService = apiService

        attachObservers()
    }

    func refreshMovieListings() {
        loadMoreMovies(shouldRefresh: true)
    }
    
    func loadMoreMovies(forceLoad: Bool = false, shouldRefresh: Bool = false) {
        if !forceLoad {
            guard !isLoadingInProgress else { return }
            isLoadingInProgress = true
        }
        
        if shouldRefresh {
            currentPage = 1
            cellViewModels.removeAll()
        }
        
        movieListingsAPIService?
            .getTrendingMoviesList(page: currentPage)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.currentPage += 1
                case .failure(let error):
                    print("An error occurred during API call: \(error)")
                }
                self.isLoadingInProgress = false
            }, receiveValue: { [weak self] movieListings in
                guard let self = self else { return }
                self.totalPages = movieListings.totalPages
                self.cellViewModels.append(contentsOf: movieListings.results.map({ MovieListingsCellViewModel(with: $0, configuration: self.configuration) }))
            })
            .store(in: &cancellables)
    }
    
    func pushMovieDetailsViewController(for itemAtIndex: Int) {
        guard let configuration = configuration else { return }
        movieDetailsNavigationService?.pushMovieDetailsViewController(with: cellViewModels[itemAtIndex].movieResponse, configuration: configuration)
    }
    
    private func attachObservers() {
        isLoadingInProgress = true
        configurationAPIService?
            .getConfiguration()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.loadMoreMovies(forceLoad: true)
                case .failure(let error):
                    print("Error during configuration fetch: \(error)")
                    self.isLoadingInProgress = false
                }
            }, receiveValue: { [weak self] in self?.configuration = $0 })
            .store(in: &cancellables)
    }
}
