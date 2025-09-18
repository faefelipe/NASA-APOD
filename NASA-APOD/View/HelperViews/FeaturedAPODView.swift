//
//  FeaturedAPODView.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import UIKit
import Kingfisher

class FeaturedAPODView: UIView {
    
    var onPreviousButtonTapped: (() -> Void)?
    var onNextButtonTapped: (() -> Void)?
    
    let imageView = UIImageView()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let previousPod = NavigationPodView(direction: .previous)
    private let nextPod = NavigationPodView(direction: .next)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupPodGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 12
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 3
        
        // --- Layout com StackViews ---
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 8
        
        let navigationStackView = UIStackView(arrangedSubviews: [previousPod, nextPod])
        navigationStackView.distribution = .fillEqually
        navigationStackView.spacing = 16
        
        let mainStackView = UIStackView(arrangedSubviews: [imageView, textStackView, navigationStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.6)
        ])
    }
    
    private func setupPodGestures() {
        let previousTap = UITapGestureRecognizer(target: self, action: #selector(didTapPrevious))
        previousPod.addGestureRecognizer(previousTap)
        
        let nextTap = UITapGestureRecognizer(target: self, action: #selector(didTapNext))
        nextPod.addGestureRecognizer(nextTap)
    }
    
    func configure(featured: APOD, previous: APOD?, next: APOD?) {
        titleLabel.text = featured.title
        descriptionLabel.text = featured.explanation
        
        let url = URL(string: featured.url)
        let placeholder = UIImage(systemName: "photo.on.rectangle.angled")
        imageView.kf.setImage(with: url, placeholder: placeholder)
        
        if let prevAPOD = previous {
            previousPod.configure(with: prevAPOD)
            previousPod.isHidden = false
        } else {
            previousPod.isHidden = true
        }
        
        // Configura o pod do próximo dia
        if let nextAPOD = next {
            nextPod.configure(with: nextAPOD)
            nextPod.isHidden = false
        } else {
            nextPod.isHidden = true
        }
    }
    
    @objc private func didTapPrevious() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        onPreviousButtonTapped?()
    }
    
    @objc private func didTapNext() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        onNextButtonTapped?()
    }
}

// MARK: - NavigationPodView
private class NavigationPodView: UIView {
    enum Direction { case previous, next }
    
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    
    init(direction: Direction) {
        super.init(frame: .zero)
        setupUI(direction: direction)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI(direction: Direction) {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 10
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 6
        thumbnailImageView.backgroundColor = .systemGray4
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        let stackView: UIStackView
        if direction == .previous {
            stackView = UIStackView(arrangedSubviews: [thumbnailImageView, titleLabel])
            titleLabel.textAlignment = .left
        } else {
            stackView = UIStackView(arrangedSubviews: [titleLabel, thumbnailImageView])
            titleLabel.textAlignment = .right
        }
        
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = direction == .previous ? "Previous" : "Next"
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 44),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(with apod: APOD) {
        let url = URL(string: apod.url)
        let placeholder = UIImage(systemName: "photo")
        thumbnailImageView.kf.setImage(with: url, placeholder: placeholder)
    }
}
