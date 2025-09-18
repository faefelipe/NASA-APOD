//
//  SplashScreenViewController.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import UIKit

@MainActor
class SplashScreenViewController: UIViewController {

    var onAccessAppTapped: (() -> Void)?

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nasa-logo")
        imageView.tintColor = ColorManager.primaryText
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "title.picture.nasa".localized
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = ColorManager.primaryText
        label.textAlignment = .center
        return label
    }()

    private let accessButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("title.access.app".localized, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = ColorManager.primaryAccent
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let backgroundAnimationView = StarfieldView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAnimationForCurrentTheme()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAnimationForCurrentTheme()
        }
    }
    
    private func updateAnimationForCurrentTheme() {
        if traitCollection.userInterfaceStyle == .dark {
            backgroundAnimationView.backgroundColor = .black
            backgroundAnimationView.starColor = .white
            appTitleLabel.textColor = .white
            logoImageView.tintColor = .white
        } else {
            backgroundAnimationView.backgroundColor = ColorManager.primaryBackground
            backgroundAnimationView.starColor = UIColor.darkGray
            appTitleLabel.textColor = .black
            logoImageView.tintColor = .black
        }
        backgroundAnimationView.reconfigureEmitter()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorManager.primaryBackground
        backgroundAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView(arrangedSubviews: [logoImageView, appTitleLabel, accessButton])
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 20
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.setCustomSpacing(40, after: appTitleLabel)
        
        view.addSubview(backgroundAnimationView)
        view.addSubview(mainStackView)
        view.sendSubviewToBack(backgroundAnimationView)
        
        NSLayoutConstraint.activate([
            backgroundAnimationView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundAnimationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundAnimationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundAnimationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            appTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            accessButton.widthAnchor.constraint(equalToConstant: 200),
            accessButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        accessButton.addTarget(self, action: #selector(accessButtonTapped), for: .touchUpInside)
    }
    
    @objc private func accessButtonTapped() {
        onAccessAppTapped?()
    }
}
