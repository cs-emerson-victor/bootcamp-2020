//
//  TabBarController.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 25/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.tabBar.barTintColor = .black
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor(red: 0.92, green: 0.60, blue: 0.18, alpha: 1.00)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
