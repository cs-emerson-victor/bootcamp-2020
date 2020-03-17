//
//  AppCoordinator.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    let presenter: UIWindow
    let rootController: UINavigationController
    let tabBar: UITabBarController
    let localService: LocalService
    let networkService: NetworkService
    var childCoordinators: [Coordinator]
    
    init(presenter: UIWindow,
         rootController: UINavigationController = UINavigationController(),
         localService: LocalService = RealmManager(),
         networkService: NetworkService = APIManager()) {
        
        self.presenter = presenter
        self.rootController = rootController
        rootController.isNavigationBarHidden = true
        self.tabBar = UITabBarController()
        self.localService = localService
        self.networkService = networkService
        self.childCoordinators = []
    }
    
    func start() {
        let homeCoordinator: HomeCoordinator = HomeCoordinator(service: networkService)
        homeCoordinator.start()
        add(homeCoordinator)
        
        let favoritesCoordinator: FavoritesCoordinator = FavoritesCoordinator(service: localService)
        favoritesCoordinator.start()
        add(favoritesCoordinator)
        
        tabBar.viewControllers = [
            homeCoordinator.rootController,
            favoritesCoordinator.rootController
        ]
        
        rootController.pushViewController(tabBar, animated: true)
        presenter.rootViewController = rootController
        presenter.makeKeyAndVisible()
    }
}
