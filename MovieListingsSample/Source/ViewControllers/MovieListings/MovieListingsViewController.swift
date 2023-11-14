//
//  MovieListingsViewController.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import Combine
import UIKit
import SnapKit
import SDWebImage

class MovieListingsCellViewModel {
    
    private struct Constants {
        static let imageSize500px = "w500"
        static let imageSizeOriginal = "original"
    }

    private let movieResponse: TrendingMoviesResponse.Movie
    
    private var configuration: ConfigurationResponse?
    
    var title: String { movieResponse.title }
    
    var imagePath: String {
        guard let configuration = configuration else { return "" }
        
        let imageSize = configuration.images.posterSizes.first(where: { $0 == Constants.imageSize500px }) ?? Constants.imageSizeOriginal
        return "\(configuration.images.secureBaseUrl)\(imageSize)/\(movieResponse.posterPath)"
    }
    
    init(with movieResponse: TrendingMoviesResponse.Movie, configuration: ConfigurationResponse?) {
        self.movieResponse = movieResponse
        self.configuration = configuration
    }
}

class MovieListingsViewModel {

    private weak var apiService: APIService?
    private weak var configurationAPIService: ConfigurationAPIService? { apiService as? ConfigurationAPIService }
    private weak var movieListingsAPIService: MovieListingsAPIService? { apiService as? MovieListingsAPIService }

    private weak var navigationService: NavigationService?

    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    private var totalPages = 1
    
    private var hasMoreResults: Bool { totalPages < currentPage }
    
    private(set) var configuration: ConfigurationResponse?
    private(set) var cellViewModels: [MovieListingsCellViewModel] = []

    @Published private(set) var isLoadingInProgress = false
    
    init(with navigationService: NavigationService?, apiService: APIService) {
        self.navigationService = navigationService
        self.apiService = apiService

        attachObservers()
    }

    func refreshMovieListings() {
        loadMoreMovies()
    }
    
    func loadMoreMovies(forceLoad: Bool = false) {
        if !forceLoad {
            guard !isLoadingInProgress else { return }
            isLoadingInProgress = true
        }
        
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
                self.cellViewModels.append(contentsOf: movieListings.results.map({ MovieListingsCellViewModel(with: $0, configuration: self.configuration) }))
            })
            .store(in: &cancellables)
    }
    
    private func attachObservers() {
        isLoadingInProgress = true
        configurationAPIService?
            .getConfiguration()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.loadMoreMovies(forceLoad: true)
                case .failure(let error):
                    print("Error during configuration fetch: \(error)")
                    self.isLoadingInProgress = false
                }
            }, receiveValue: { [weak self] in self?.configuration = $0 })
            .store(in: &cancellables)
    }
}

class MovieListingTableViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
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

    func configure(with viewModel: MovieListingsCellViewModel, configuration: ConfigurationResponse) {
        titleLabel.text = viewModel.title
        
        backgroundImageView.sd_setImage(with: URL(string: viewModel.imagePath))
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(overlayView)
        containerView.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        overlayView.snapToSuperview()
        backgroundImageView.snapToSuperview()

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
