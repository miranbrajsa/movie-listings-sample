//
//  MLSAPIService+Configuration.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Combine
import Foundation

extension MLSAPIService: ConfigurationAPIService {
    
    func getConfiguration() -> AnyPublisher<ConfigurationResponse, APIError> {
        return request(with: API.GET.configuration.url, httpMethod: .get)
    }
}
