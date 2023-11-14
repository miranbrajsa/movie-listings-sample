//
//  MLSAPIService+MovieListingsAPIService.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Combine
import Foundation

extension MLSAPIService: MovieListingsAPIService {

    func getTrendingMoviesList(page: Int = 1) -> AnyPublisher<TrendingMoviesResponse, APIError> {
        return request(with: API.GET.trendingMovies(page: page).url, httpMethod: .get)
    }
}
