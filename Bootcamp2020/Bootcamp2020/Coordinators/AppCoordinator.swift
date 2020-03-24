//
//  AppCoordinator.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    let presenter: UIWindow
    let rootController: UINavigationController
    let tabBar: UITabBarController
    let localService: LocalService?
    let networkService: Service
    var childCoordinators: [Coordinator]
    
    init(presenter: UIWindow,
         rootController: UINavigationController = UINavigationController(),
         localService: LocalService?,
         networkService: Service = APIManager()) {
        
        self.presenter = presenter
        self.rootController = rootController
        rootController.isNavigationBarHidden = true
        self.tabBar = UITabBarController()
        self.localService = localService
        self.networkService = networkService
        self.childCoordinators = []
    }
    
    init(presenter: UIWindow,
         rootController: UINavigationController = UINavigationController(),
         networkService: Service = APIManager()) {
        
        self.presenter = presenter
        self.rootController = rootController
        rootController.isNavigationBarHidden = true
        self.tabBar = UITabBarController()
        self.networkService = networkService
        self.childCoordinators = []
        do {
            self.localService = try RealmManager()
        } catch {
            self.localService = nil
        }
    }
    
    func start() {
        guard let localService = self.localService else {
            presenter.rootViewController = UIViewController()
            presenter.makeKeyAndVisible()
            self.presentInitializationError(in: presenter.rootViewController)
            
            return
        }
        
        let homeCoordinator: HomeCoordinator = HomeCoordinator(localService: localService, networkService: networkService)
        homeCoordinator.start()
        add(homeCoordinator)
        
        let favoritesCoordinator: FavoritesCoordinator = FavoritesCoordinator(localService: localService)
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
    
    func presentInitializationError(in controller: UIViewController?) {
        let alert = UIAlertController(title: "Ops, we had a problem :(",
                                      message: "We had a problem loading your information. Please restart the application.",
                                      preferredStyle: .alert)
        controller?.present(alert, animated: true, completion: nil)
    }
}
