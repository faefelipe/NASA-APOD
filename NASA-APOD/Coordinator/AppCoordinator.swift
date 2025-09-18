//
//  AppCoordinator.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.

import UIKit

@MainActor
class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private(set) var window: UIWindow
    private var tabBarController: UITabBarController!
    
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let splashScreenVC = SplashScreenViewController()
        splashScreenVC.onAccessAppTapped = { [weak self] in
            self?.showMainContent()
        }
        
        window.rootViewController = splashScreenVC
        window.makeKeyAndVisible()
    }
    
    private func showMainContent() {
        if tabBarController == nil {
            tabBarController = UITabBarController()
            
            let apodListNavigationController = UINavigationController()
            let apodListTabBarItem = UITabBarItem(
                title: "title.start".localized,
                image: UIImage(systemName: "house"),
                selectedImage: UIImage(systemName: "house.fill")
            )
            apodListNavigationController.tabBarItem = apodListTabBarItem
            let apodListCoordinator = APODListCoordinator(navigationController: apodListNavigationController)
            
            let favoritesNavigationController = UINavigationController()
            let favoritesTitle = "title.favorites".localized
            let favoritesTabBarItem = UITabBarItem(
                title: favoritesTitle,
                image: UIImage(systemName: "star"),
                selectedImage: UIImage(systemName: "star.fill")
            )
            favoritesNavigationController.tabBarItem = favoritesTabBarItem
            let favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNavigationController)

            childCoordinators = [apodListCoordinator, favoritesCoordinator]
            apodListCoordinator.start()
            favoritesCoordinator.start()
            
            tabBarController.viewControllers = [
                apodListNavigationController,
                favoritesNavigationController
            ]

            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = ColorManager.primaryBackground
            appearance.stackedLayoutAppearance.normal.iconColor = ColorManager.secondaryText
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: ColorManager.secondaryText
            ]
            
            appearance.stackedLayoutAppearance.selected.iconColor = ColorManager.primaryAccent
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: ColorManager.primaryAccent
            ]
            
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        UIView.transition(
            with: window,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                self.window.rootViewController = self.tabBarController
            },
            completion: nil
        )
    }
}
