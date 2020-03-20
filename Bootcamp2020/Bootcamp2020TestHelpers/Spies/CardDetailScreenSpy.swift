//
//  CardDetailScreenSpy.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 19/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import UIKit

final class CardDetailScreenSpy: CardDetailScreen {
    var countBind: Int = 0
    
    override func bind(to viewModel: CardDetailViewModel) {
        countBind += 1
    }
}
