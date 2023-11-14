//
//  UITableView+Extensions.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit

extension UITableView {
    
    func dequeueCellAtIndexPath<T: UITableViewCell>(indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identity, for: indexPath) as? T
        else {
            fatalError("Cell with \"\(T.identity)\" identifier is not registered!")
        }
        return cell
    }
}
