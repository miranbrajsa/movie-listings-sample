//
//  APIService+Types.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Foundation

struct HTTPHeaders {
    
    enum Key: String {
        case contentType = "Content-Type"
    }
    
    enum Value: String {
        case applicationJSON = "application/json"
    }
}

struct HTTPHeaderData {
    let value: HTTPHeaders.Value
    let key: HTTPHeaders.Key
}

enum APIError: Error, CustomDebugStringConvertible {
    case decodingError
    case serverError(String)
    case urlError(URLError)
    case unknown
    
    var debugDescription: String {
        switch self {
        case .decodingError:
            return "Decoding error"
        case .serverError(let error):
            return "Server error: \(error)"
        case .urlError(let urlError):
            return "URLError: \(urlError.localizedDescription)"
        case .unknown:
            return "Unknown error"
        }
    }
}
