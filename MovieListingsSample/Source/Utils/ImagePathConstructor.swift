//
//  ImagePathConstructor.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Foundation

class ImagePathConstructor {

    private struct Constants {
        static let imageSize500px = "w500"
        static let imageSizeOriginal = "original"
    }

    static func constructFullImagePath(given configuration: ConfigurationResponse, imagePath: String) -> String {
        let imageSize = configuration.images.posterSizes.first(where: { $0 == Constants.imageSize500px }) ?? Constants.imageSizeOriginal
        return "\(configuration.images.secureBaseUrl)\(imageSize)/\(imagePath)"
    }
}
