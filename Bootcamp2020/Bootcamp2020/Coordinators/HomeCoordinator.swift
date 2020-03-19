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
    var localService: LocalService
    var networkService: Service
    
    init(rootController: UINavigationController = UINavigationController(),
         localService: LocalService = RealmManager(),
         networkService: Service = APIManager()) {
        
        self.rootController = rootController
        rootController.isNavigationBarHidden = true
        self.childCoordinators = []
        self.localService = localService
        self.networkService = networkService
    }
    
    func start() {
        let controller = CardListViewController(service: networkService, detailDelegate: self)
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        rootController.pushViewController(controller, animated: true)
    }
}

extension HomeCoordinator: ShowCardDetailDelegate {
    var saver: CardSaverProtocol {
        return localService
    }
}
