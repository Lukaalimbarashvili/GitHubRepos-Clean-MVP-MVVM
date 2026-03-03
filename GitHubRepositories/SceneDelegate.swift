//
//  SceneDelegate.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 30.12.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create UIWindow
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        // get ReposVC and embed in UINavigationController
        
        let reposVC = ReposMVPConfigurator.getReposVC()
//        let reposVC = ReposMVVMConfigurator.getReposVC()
        
        
        let navigationController = UINavigationController(rootViewController: reposVC)
        
        // Set as root
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
