//
//  FavoritesCoordinator.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import UIKit

@MainActor
class FavoritesCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.navigationBar.tintColor = .label
        
        let viewModel = FavoritesViewModel()
        viewModel.onSelectAPOD = { [weak self] apod in
            self?.showDetail(for: apod)
        }
        
        let viewController = FavoritesViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }

    private func showDetail(for apod: APOD) {
        let detailViewModel = APODDetailViewModel(apod: apod)
        let detailViewController = APODDetailViewController(viewModel: detailViewModel)
        detailViewController.title = "title.details".localized
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
