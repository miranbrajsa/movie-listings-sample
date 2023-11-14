//
//  APIService.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Combine
import Foundation

protocol APIService: AnyObject {}

protocol MovieListingsAPIService: APIService {
    func getTrendingMoviesList(page: Int) -> AnyPublisher<TrendingMoviesResponse, APIError>
}
