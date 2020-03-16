//
//  AppCoordinator.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var presenter: UIWindow
    var rootController: UINavigationController
    var childCoordinators: [Coordinator]
    var localService: LocalService
    var networkService: NetworkService
    
    init(presenter: UIWindow,
         rootController: UINavigationController = UINavigationController(),
         localService: LocalService = CoreDataManager(),
         networkService: NetworkService = APIManager()) {
        
        self.presenter = presenter
        self.rootController = rootController
        rootController.isNavigationBarHidden = true
        self.childCoordinators = []
        self.localService = localService
        self.networkService = networkService
    }
    
    func start() {
        let homeCoordinator: HomeCoordinator = HomeCoordinator(service: networkService)
        homeCoordinator.start()
        add(homeCoordinator)
        
        let favoritesCoordinator: FavoritesCoordinator = FavoritesCoordinator(service: localService)
        favoritesCoordinator.start()
        add(favoritesCoordinator)
        
        let tabBar: UITabBarController = UITabBarController()
        tabBar.viewControllers = [
            homeCoordinator.rootController,
            favoritesCoordinator.rootController
        ]
        
        rootController.pushViewController(tabBar, animated: true)
        presenter.rootViewController = rootController
        presenter.makeKeyAndVisible()
    }
}
