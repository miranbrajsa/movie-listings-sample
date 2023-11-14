//
//  MovieDetailsContentView.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit
import SnapKit
import SDWebImage

protocol MovieDetailsContentViewDelegate: AnyObject {
    var imagePath: String { get }
    var year: String { get }
    var movieTitle: String { get }
    var movieDescription: String { get }
}

class MovieDetailsContentView: UIView {

    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .semibold)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var verticalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        return scrollView
    }()

    weak var delegate: MovieDetailsContentViewDelegate?
    
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
        addSubview(verticalScrollView)
        
        verticalScrollView.addSubview(containerView)
        
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(overlayView)
        containerView.addSubview(yearLabel)
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        
        containerView.addSubview(verticalStackView)
    }
    
    private func setConstraints() {
        verticalScrollView.snapToSuperview()
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(240)
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalTo(backgroundImageView)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.trailing.equalTo(overlayView).offset(-16)
            make.bottom.equalTo(overlayView).offset(-16)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.bottom.equalToSuperview().offset(-16)
            make.top.equalTo(overlayView.snp.bottom).offset(32)
        }
    }
    
    func updateData() {
        guard let delegate = delegate else { return }
        
        backgroundImageView.sd_setImage(with: URL(string: delegate.imagePath))
        yearLabel.text = delegate.year
        titleLabel.text = delegate.movieTitle
        descriptionLabel.text = delegate.movieDescription
    }
    
    private func setupAppearance() {
        backgroundColor = .systemBackground
    }
}
