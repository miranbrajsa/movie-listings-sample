//
//  MovieListingsViewController+Delegates.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit

extension MovieListingsViewController: MovieListingsContentViewDelegate {

    func didPullToRefresh() {
        contentView.listingsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        viewModel.refreshMovieListings()
    }
}

extension MovieListingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // TODO: Push movie details view controller here
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.cellViewModels.count - indexPath.row < MovieListingsViewController.Constants.paginationThreshold {
            viewModel.loadMoreMovies()
        }
    }
}

extension MovieListingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let configuration = viewModel.configuration else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let cell: MovieListingTableViewCell = tableView.dequeueCellAtIndexPath(indexPath: indexPath)

        cell.configure(with: cellViewModel, configuration: configuration)
        return cell
    }
}
