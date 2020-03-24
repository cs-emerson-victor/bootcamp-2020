//
//  ViewControllerSpy.swift
//  Bootcamp2020
//
//  Created by emerson.victor.f.luz on 24/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import UIKit

final class ViewControllerSpy: UIViewController {
    var presentWasCalled = false
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        presentWasCalled = true
    }
}
