//
//  APODDetailViewController.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import UIKit
import Kingfisher

class APODDetailViewController: UIViewController {

    private let viewModel: APODDetailViewModel
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let explanationLabel = UILabel()
    
    private var favoriteBarButtonItem: UIBarButtonItem!

    init(viewModel: APODDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureContent()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "title.details".localized
        favoriteBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = favoriteBarButtonItem
        updateFavoriteButtonIcon(isFavorite: viewModel.isFavorite)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [imageView, titleLabel, dateLabel, explanationLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.numberOfLines = 0
        
        dateLabel.font = .preferredFont(forTextStyle: .subheadline)
        dateLabel.textColor = .secondaryLabel
        
        explanationLabel.font = .preferredFont(forTextStyle: .body)
        explanationLabel.numberOfLines = 0

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.75),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            explanationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            explanationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            explanationLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            explanationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureContent() {
       let apod = viewModel.apod
       titleLabel.text = apod.title
       dateLabel.text = apod.date
       explanationLabel.text = apod.explanation
       let url = URL(string: apod.hdurl ?? apod.url)
       let placeholder = UIImage(systemName: "photo.on.rectangle.angled")
       imageView.kf.setImage(with: url, placeholder: placeholder)
    }
    
    private func bindViewModel() {
        viewModel.onFavoriteStatusChange = { [weak self] isFavorite in
            self?.updateFavoriteButtonIcon(isFavorite: isFavorite)
        }
    }
    
    private func updateFavoriteButtonIcon(isFavorite: Bool) {
        let iconName = isFavorite ? "star.fill" : "star"
        favoriteBarButtonItem.image = UIImage(systemName: iconName)
        favoriteBarButtonItem.tintColor = .systemYellow
    }
    
    @objc private func favoriteButtonTapped() {
        viewModel.toggleFavorite()
    }
}
