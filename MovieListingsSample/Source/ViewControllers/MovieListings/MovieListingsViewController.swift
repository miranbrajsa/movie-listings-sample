//
//  MovieListingsViewController.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Combine
import UIKit
import SnapKit

class MovieListingsViewModel {

    private weak var apiService: APIService?
    private weak var movieListingsAPIService: MovieListingsAPIService? { apiService as? MovieListingsAPIService }

    private weak var navigationService: NavigationService?

    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    private var totalPages = 1
    
    private var hasMoreResults: Bool { totalPages < currentPage }
    
    private(set) var cellModels: [TrendingMoviesResponse.Movie] = []

    @Published private(set) var isLoadingInProgress = false
    
    init(with navigationService: NavigationService?, apiService: APIService) {
        self.navigationService = navigationService
        self.apiService = apiService

        attachObservers()
    }

    func refreshMovieListings() {
        loadMoreMovies()
    }
    
    func loadMoreMovies() {
        guard !isLoadingInProgress else { return }
        
        isLoadingInProgress = true
        movieListingsAPIService?
            .getTrendingMoviesList(page: currentPage)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.currentPage += 1
                case .failure(let error):
                    print("An error occurred during API call: \(error)")
                }
                self.isLoadingInProgress = false
            }, receiveValue: { [weak self] movieListings in
                guard let self = self else { return }
                self.totalPages = movieListings.totalPages
                self.cellModels.append(contentsOf: movieListings.results)
            })
            .store(in: &cancellables)
    }
    
    private func attachObservers() {
        refreshMovieListings()
    }
}

class MovieListingTableViewCell: UITableViewCell {

    private var model: TrendingMoviesResponse.Movie?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: TrendingMoviesResponse.Movie) {
        self.model = model
        
        titleLabel.text = model.title
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.bottom.equalToSuperview().offset(-4)
            make.height.equalTo(160)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(12)
            make.trailing.equalTo(-12)
        }
    }
    
    private func setupAppearance() {
        containerView.backgroundColor = .tertiarySystemGroupedBackground
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}

protocol MovieListingsContentViewDelegate: AnyObject {
    func didPullToRefresh()
}

class MovieListingsContentView: UIView {

    private lazy var systemImageConfiguration: UIImage.SymbolConfiguration = {
        UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .default)
    }()

    lazy var refreshBarButtonItem: UIBarButtonItem = {
        let image = UIImage(systemName: "arrow.clockwise", withConfiguration: systemImageConfiguration)
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didPullToRefresh))
        return barButtonItem
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addAction(UIAction(title: "PullToRefreshAction", handler: { [weak self] _ in
            self?.delegate?.didPullToRefresh()
        }), for: .valueChanged)
        return refreshControl
    }()

    lazy var listingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(MovieListingTableViewCell.self, forCellReuseIdentifier: MovieListingTableViewCell.identity)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = refreshControl
        return tableView
    }()

    weak var delegate: MovieListingsContentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setConstraints()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(listingsTableView)
    }
    
    private func setConstraints() {
        listingsTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-40)
        }
    }
    
    private func setupAppearance() {
        listingsTableView.backgroundColor = .systemBackground
    }
    
    @objc private func didPullToRefresh() {
        delegate?.didPullToRefresh()
    }
}

extension MovieListingsViewController: MovieListingsContentViewDelegate {

    func didPullToRefresh() {
        viewModel.refreshMovieListings()
    }
}

extension MovieListingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // TODO: Push movie details view controller here
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.cellModels.count - indexPath.row < MovieListingsViewController.Constants.paginationThreshold {
            viewModel.loadMoreMovies()
        }
    }
}

extension MovieListingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel.cellModels[indexPath.row]
        let cell: MovieListingTableViewCell = tableView.dequeueCellAtIndexPath(indexPath: indexPath)

        cell.configure(with: cellModel)
        return cell
    }
}

class MovieListingsViewController: UIViewController {
    
    struct Constants {
        static let paginationThreshold: Int = 5
    }
    
    private let viewModel: MovieListingsViewModel

    private var cancellables = Set<AnyCancellable>()

    private lazy var contentView: MovieListingsContentView = {
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
