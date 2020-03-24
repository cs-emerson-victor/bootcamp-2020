//
//  UINavigationControllerSpy.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 23/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import UIKit

final class UINavigationControllerSpy: UINavigationController {
    
    var dismissWasCalled = false
    var showWasCalled = false
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        dismissWasCalled = true
    }
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        showWasCalled = true
    }
}
