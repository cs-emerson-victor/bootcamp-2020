//
//  CoordinatorSpy.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 23/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import UIKit

final class CoordinatorSpy: Coordinator {
    
    var rootController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        self.childCoordinators = []
    }
    
    func start() {
        
    }
}

extension CoordinatorSpy: DismissCardDetailDelegate { }
