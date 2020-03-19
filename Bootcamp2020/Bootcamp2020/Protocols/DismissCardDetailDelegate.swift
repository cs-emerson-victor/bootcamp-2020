//
//  DismissCardDetailDelegate.swift
//  Bootcamp2020
//
//  Created by emerson.victor.f.luz on 19/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

protocol DismissCardDetailDelegate: AnyObject {
    
    func dismissDetail(animated: Bool)
}

extension DismissCardDetailDelegate where Self: Coordinator {
    
    func dismissDetail(animated: Bool = true) {
        rootController.dismiss(animated: animated, completion: nil)
    }
}
