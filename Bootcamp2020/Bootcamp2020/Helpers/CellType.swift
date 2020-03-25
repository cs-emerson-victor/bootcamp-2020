//
//  CellType.swift
//  Bootcamp2020
//
//  Created by alexandre.c.ferreira on 25/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

enum CellType {
    case card(_ viewModel: CardCellViewModel)
    case typeHeader(_ title: String)
}
