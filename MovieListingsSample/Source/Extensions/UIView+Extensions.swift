//
//  UIView+Extensions.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit
import SnapKit

extension UIView {

    static var identity: String {
        return String(describing: self)
    }

    func snapToSuperview() {
        snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
