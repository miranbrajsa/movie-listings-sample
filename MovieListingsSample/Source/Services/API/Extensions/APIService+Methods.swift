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
        
        enum TimeWindow: String {
            case day
            case week
        }
    }

    enum GET {
        case trendingMovies(Constants.TimeWindow)
    }
}

extension API.GET {
        
    var url: URLComponents {
        switch self {
        case .trendingMovies(let timeWindow):
            guard var components = URLComponents(string: "\(API.Constants.baseURL)/trending/movie/\(timeWindow.rawValue)") else {
                fatalError("Unable to construct components.")
            }
            
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "language", value: "en-US")
            ]
            components.queryItems = queryItems

            return components
        }
    }
}
