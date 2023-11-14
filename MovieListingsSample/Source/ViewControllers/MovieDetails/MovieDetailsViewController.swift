//
//  MovieDetailsViewController.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit
import SnapKit

class MovieDetailsViewController: UIViewController {
    
    let viewModel: MovieDetailsViewModel
    
    private lazy var contentView: MovieDetailsContentView = {
        let contentView = MovieDetailsContentView()
        contentView.delegate = self
        return contentView
    }()
    
    init(with viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        addSubviews()
        setConstraints()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.updateData()
    }
    
    private func addSubviews() {
        view.addSubview(contentView)
    }
    
    private func setConstraints() {
        contentView.snapToSuperview()
    }
    
    private func setupAppearance() {
        navigationItem.title = viewModel.title
        
        view.backgroundColor = .systemBackground
    }
}
