//
//  APODListViewController.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import UIKit
import Combine
import Kingfisher

@MainActor
class APODListViewController: UIViewController {

    private let viewModel: APODListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()

    init(viewModel: APODListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "title.start".localized
        self.tabBarItem.title = "title.start".localized
        
        setupUI()
        bindViewModel()
        viewModel.fetchData(forceRefreshRecents: true)
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
        
        tableView.register(FeaturedAPODTableViewCell.self, forCellReuseIdentifier: FeaturedAPODTableViewCell.reuseIdentifier)
        tableView.register(APODTableViewCell.self, forCellReuseIdentifier: APODTableViewCell.reuseIdentifier)
        
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        activityIndicator.color = ColorManager.primaryText
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)

        [tableView, activityIndicator, errorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func refreshData() {
        viewModel.refreshToLatest()
    }

    private func bindViewModel() {
        viewModel.onStateUpdate = { [weak self] state in
            DispatchQueue.main.async {
                if state != .loading {
                    self?.tableView.refreshControl?.endRefreshing()
                }
                self?.updateUI(for: state)
            }
        }
    }
    
    private func updateUI(for state: APODListViewModel.State) {
        errorLabel.isHidden = true
        activityIndicator.stopAnimating()
        
        switch state {
        case .loading:
            if viewModel.featuredAPOD == nil {
                activityIndicator.startAnimating()
                tableView.isHidden = true
            }
        case .success:
            tableView.isHidden = false
            tableView.reloadData()
        case .error(let message):
            tableView.isHidden = true
            errorLabel.isHidden = false
            errorLabel.text = message
        }
    }
}

extension APODListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let featuredSection = viewModel.featuredAPOD == nil ? 0 : 1
        return featuredSection + viewModel.recentAPODs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FeaturedAPODTableViewCell.reuseIdentifier, for: indexPath) as! FeaturedAPODTableViewCell
            if let featured = viewModel.featuredAPOD {
                cell.configure(featured: featured, previous: viewModel.previousAPOD, next: viewModel.nextAPOD)
            }
            cell.selectionStyle = .none
            cell.onPreviousButtonTapped = { [weak self] in self?.viewModel.getPreviousDay() }
            cell.onNextButtonTapped = { [weak self] in self?.viewModel.getNextDay() }
            cell.onFeaturedImageTapped = { [weak self] in self?.viewModel.didSelectFeaturedAPOD() }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: APODTableViewCell.reuseIdentifier, for: indexPath) as! APODTableViewCell
            let apodIndex = indexPath.section - 1
            guard apodIndex < viewModel.recentAPODs.count else { return cell }
            let apod = viewModel.recentAPODs[apodIndex]
            cell.configure(with: apod)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30
        }
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        return 4
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        let apodIndex = indexPath.section - 1
        guard apodIndex < viewModel.recentAPODs.count else { return }
        let apod = viewModel.recentAPODs[apodIndex]
        viewModel.didSelect(apod: apod)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 && !viewModel.recentAPODs.isEmpty {
            return "title.photos.recent".localized
        }
        return nil
    }
}

extension APODListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let resources = indexPaths.compactMap { indexPath -> Kingfisher.ImageResource? in
            guard indexPath.section > 0 else { return nil }
            let apodIndex = indexPath.section - 1
            guard apodIndex < viewModel.recentAPODs.count else { return nil }
            let urlString = viewModel.recentAPODs[apodIndex].url
            guard let url = URL(string: urlString) else { return nil }
            return Kingfisher.ImageResource(downloadURL: url)
        }
        ImagePrefetcher(resources: resources).start()
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        let resources = indexPaths.compactMap { indexPath -> Kingfisher.ImageResource? in
            guard indexPath.section > 0 else { return nil }
            let apodIndex = indexPath.section - 1
            guard apodIndex < viewModel.recentAPODs.count else { return nil }
            let urlString = viewModel.recentAPODs[apodIndex].url
            guard let url = URL(string: urlString) else { return nil }
            return Kingfisher.ImageResource(downloadURL: url)
        }
        ImagePrefetcher(resources: resources).stop()
    }
}
