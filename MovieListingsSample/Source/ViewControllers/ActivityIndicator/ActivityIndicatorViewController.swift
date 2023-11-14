//
//  ActivityIndicatorViewController.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import RappleProgressHUD
import UIKit

class ActivityIndicatorController {
    
    private var startCountBlocking: Int = 0
    
    static let shared = ActivityIndicatorController()
    
    private let attributes = RappleActivityIndicatorView.attribute(style: RappleStyle.circle, tintColor: .white, screenBG: UIColor.black.withAlphaComponent(0.6), progressBG: .white, progressBarBG: UIColor.black.withAlphaComponent(0.6), progreeBarFill: .white, thickness: 4)
    
    func startAnimating() {
        startCountBlocking += 1
        if startCountBlocking == 1 {
            RappleActivityIndicatorView.startAnimating(attributes: attributes)
        }
    }
    
    func stopAnimating(forceStop: Bool = false) {
        startCountBlocking = max(0, startCountBlocking - 1)
        if startCountBlocking == 0 || forceStop {
            RappleActivityIndicatorView.stopAnimation()
        }
    }
}
