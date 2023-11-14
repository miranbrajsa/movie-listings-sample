//
//  APIService+Methods.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum API {
    struct Constants {
        static let baseURL = "https://api.themoviedb.org/3"
    }

    enum GET {
        case trendingMovies(page: Int)
    }
}

extension API.GET {
        
    var url: URLComponents {
        switch self {
        case .trendingMovies(let page):
            guard var components = URLComponents(string: "\(API.Constants.baseURL)/discover/movie") else {
                fatalError("Unable to construct components.")
            }
            
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "sort_by", value: "popularity.desc"),
            ]
            components.queryItems = queryItems

            return components
        }
    }
}
