//
//  SceneDelegate.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 17/09/25.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.tintColor = ColorManager.primaryAccent
        
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()
    }
}
