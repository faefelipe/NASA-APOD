//
//  FavoritesViewController.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import UIKit
import Combine

@MainActor
class FavoritesViewController: UIViewController {
    
    private let viewModel: FavoritesViewModel
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let infoLabel = UILabel()

    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "title.favorites".localized
        
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavoriteAPODs()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorManager.primaryBackground
        tableView.backgroundColor = .clear
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = ColorManager.primaryBackground
        appearance.titleTextAttributes = [.foregroundColor: ColorManager.primaryText]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .label
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(APODTableViewCell.self, forCellReuseIdentifier: APODTableViewCell.reuseIdentifier)
        tableView.rowHeight = 110
        tableView.separatorStyle = .none
        
        activityIndicator.color = ColorManager.primaryText
        infoLabel.textColor = ColorManager.secondaryText
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.text = "title.dont.favorites".localized
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(infoLabel)
        
        [tableView, activityIndicator, infoLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func bindViewModel() {
        viewModel.$favoriteAPODs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.updateVisibility()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateVisibility()
            }
            .store(in: &cancellables)
    }
    
    private func updateVisibility() {
        if viewModel.isLoading {
            activityIndicator.startAnimating()
            tableView.isHidden = true
            infoLabel.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            if viewModel.favoriteAPODs.isEmpty {
                tableView.isHidden = true
                infoLabel.isHidden = false
            } else {
                tableView.isHidden = false
                infoLabel.isHidden = true
            }
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favoriteAPODs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: APODTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! APODTableViewCell
        let apod = viewModel.favoriteAPODs[indexPath.row]
        cell.configure(with: apod)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let apod = viewModel.favoriteAPODs[indexPath.row]
        viewModel.didSelect(apod: apod)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeFavorite(at: indexPath.row)
        }
    }
}
