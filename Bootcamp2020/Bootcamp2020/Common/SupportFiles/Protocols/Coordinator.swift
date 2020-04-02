//
//  Coordinator.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var rootController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    func add(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func remove(_ coordinator: Coordinator) {
        childCoordinators.removeAll { (childCoordinator) -> Bool in
            return childCoordinator === coordinator
        }
    }
}
