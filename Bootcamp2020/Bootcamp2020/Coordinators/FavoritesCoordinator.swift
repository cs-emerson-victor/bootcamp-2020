//
//  FavoritesCoordinator.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class FavoritesCoordinator: Coordinator {
    
    var rootController: UINavigationController
    var childCoordinators: [Coordinator]
    var localService: LocalService
    
    init(rootController: UINavigationController = UINavigationController(),
         localService: LocalService = RealmManager()) {
        
        self.rootController = rootController
        rootController.isNavigationBarHidden = true
        self.childCoordinators = []
        self.localService = localService
    }
    
    func start() {
        let controller = CardListViewController(service: localService)
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        rootController.pushViewController(controller, animated: true)
    }
}
