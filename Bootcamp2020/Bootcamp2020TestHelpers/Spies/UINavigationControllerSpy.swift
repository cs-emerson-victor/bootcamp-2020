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
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        dismissWasCalled = true
    }
}
