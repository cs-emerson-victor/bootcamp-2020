//
//  AppCordinatorSpy.swift
//  Bootcamp2020
//
//  Created by emerson.victor.f.luz on 24/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import UIKit

final class AppCoordinatorSpy: AppCoordinator {
    var presentInitializationErrorWasCalled = false
    
    override func presentInitializationError(in controller: UIViewController?) {
        super.presentInitializationError(in: controller)
        presentInitializationErrorWasCalled = true
    }
}
