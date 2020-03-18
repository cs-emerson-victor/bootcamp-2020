//
//  HomeCoordinator.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class HomeCoordinator: Coordinator {
    
    var rootController: UINavigationController
    var childCoordinators: [Coordinator]
    var service: Service
    // TODO: - Add local and remote service
    
    init(rootController: UINavigationController = UINavigationController(),
         service: Service = APIManager()) {
        
        self.rootController = rootController
        rootController.isNavigationBarHidden = true
        self.childCoordinators = []
        self.service = service
    }
    
    func start() {
        let controller = CardListViewController(service: service)
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        rootController.pushViewController(controller, animated: true)
    }
}
