//
//  MovieListingTableViewCell.swift
//  MovieListingsSample
//
//  Created by Miran Brajsa on 14.11.2023..
//

import UIKit
import SnapKit
import SDWebImage

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
