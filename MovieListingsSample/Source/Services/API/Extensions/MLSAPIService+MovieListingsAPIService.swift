//
//  MLSAPIService+MovieListingsAPIService.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Combine
import Foundation

extension MLSAPIService: MovieListingsAPIService {

    func getTrendingMoviesList() -> AnyPublisher<TrendingMoviesResponse, APIError> {
        return request(with: API.GET.trendingMovies(.day).url, httpMethod: .get)
    }
}
