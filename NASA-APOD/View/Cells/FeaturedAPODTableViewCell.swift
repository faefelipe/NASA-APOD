//
//  FeaturedAPODTableViewCell.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import UIKit

class FeaturedAPODTableViewCell: UITableViewCell {
    static let reuseIdentifier = "FeaturedAPODTableViewCell"
    
    private let featuredView = FeaturedAPODView()

    var onPreviousButtonTapped: (() -> Void)? {
        get { featuredView.onPreviousButtonTapped }
        set { featuredView.onPreviousButtonTapped = newValue }
    }
    
    var onNextButtonTapped: (() -> Void)? {
        get { featuredView.onNextButtonTapped }
        set { featuredView.onNextButtonTapped = newValue }
    }
    
    var onFeaturedImageTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(featuredView)
        featuredView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            featuredView.topAnchor.constraint(equalTo: contentView.topAnchor),
            featuredView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            featuredView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            featuredView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupGesture() {
        featuredView.imageView.isUserInteractionEnabled = true
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapFeaturedImage))
        featuredView.imageView.addGestureRecognizer(imageTap)
    }
    
    @objc private func didTapFeaturedImage() {
        onFeaturedImageTapped?()
    }
    
    func configure(featured: APOD, previous: APOD?, next: APOD?) {
        featuredView.configure(featured: featured, previous: previous, next: next)
    }
}
