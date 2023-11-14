//
//  MovieListingsViewController.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Combine
import UIKit
import SnapKit

class MovieListingsViewController: UIViewController {
    
    struct Constants {
        static let paginationThreshold: Int = 5
    }
    
    let viewModel: MovieListingsViewModel

    private var cancellables = Set<AnyCancellable>()

    lazy var contentView: MovieListingsContentView = {
        let view = MovieListingsContentView()
        view.listingsTableView.delegate = self
        view.listingsTableView.dataSource = self
        view.delegate = self
        return view
    }()
    
    init(with viewModel: MovieListingsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        addSubviews()
        setConstraints()
        setupAppearance()
        
        attachObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        view.addSubview(contentView)
    }
    
    private func setConstraints() {
        contentView.snapToSuperview()
    }
    
    private func setupAppearance() {
        navigationItem.title = "Trending"
        navigationItem.rightBarButtonItems = [contentView.refreshBarButtonItem]
        navigationItem.backButtonTitle = ""
        
        view.backgroundColor = .systemBackground
    }

    private func attachObservers() {
        viewModel
            .$isLoadingInProgress
            .sink { [weak self] inProgress in
                if inProgress {
                    ActivityIndicatorController.shared.startAnimating()
                }
                else {
                    self?.contentView.listingsTableView.reloadData()
                    self?.contentView.refreshControl.endRefreshing()
                    ActivityIndicatorController.shared.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
}
