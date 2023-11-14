//
//  MLSAPIService.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Foundation
import Combine

class MLSAPIService: APIService {
    
    private let plistReaderService: PlistReaderService
    
    private let dateFormatter: DateFormatter
    private let decoder: JSONDecoder
    
    private static let defaultHeaderData: [HTTPHeaderData] = [
        HTTPHeaderData(value: .applicationJSON, key: .contentType),
    ]
    
    init(with plistReaderService: PlistReaderService) {
        self.plistReaderService = plistReaderService
        self.dateFormatter = DateFormatter()
        self.decoder = JSONDecoder()
    }
    
    func request<T>(with components: URLComponents,
                    httpMethod: HTTPMethod,
                    httpHeaders: [HTTPHeaderData] = MLSAPIService.defaultHeaderData,
                    decodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) -> AnyPublisher<T, APIError> where T: Decodable
    {
        guard let request = assembleRequest(from: components, httpMethod: httpMethod, httpHeaders: httpHeaders)
        else { return Fail(error: APIError.unknown).eraseToAnyPublisher() }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .mapError { .urlError($0) }
            .flatMap { [weak self] data, response -> AnyPublisher<T, APIError> in
                guard let self = self,
                      let response = response as? HTTPURLResponse
                else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }
                
                self.switchDecodingStrategy(to: decodingStrategy)
                if (200...299).contains(response.statusCode) {
                    return Just(data)
                        .decode(type: T.self, decoder: self.decoder)
                        .mapError { error in
                            return .decodingError
                        }
                        .eraseToAnyPublisher()
                }
                else {
                    let error = "APISession: FAIL: \(String(data: data, encoding: .utf8) ?? "")"
                    return Fail(error: APIError.serverError(error))
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func assembleRequest(from components: URLComponents, httpMethod: HTTPMethod, httpHeaders: [HTTPHeaderData]) -> URLRequest? {
        let httpAPIKey = plistReaderService.read(.tmdbApiKey)
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: httpAPIKey)
        
        var currentQueryItems: [URLQueryItem] = components.queryItems ?? []
        currentQueryItems.append(apiKeyQueryItem)
        
        var modifiedComponents = components
        modifiedComponents.queryItems = currentQueryItems
        
        guard let url = modifiedComponents.url else { return nil }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 120)
        request.httpShouldHandleCookies = false
        request.httpMethod = httpMethod.rawValue
        
        httpHeaders.forEach { request.addValue($0.value.rawValue, forHTTPHeaderField: $0.key.rawValue) }
        
        return request
    }
    
    private func switchDecodingStrategy(to decodingStrategy: JSONDecoder.KeyDecodingStrategy) {
        decoder.keyDecodingStrategy = decodingStrategy

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
}
