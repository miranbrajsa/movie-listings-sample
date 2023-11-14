//
//  MovieListingsContentView.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit
import SnapKit

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
