//
//  CardCellSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 19/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Quick
import Nimble
@testable import Bootcamp2020

final class CardCellSpec: QuickSpec {
    
    override func spec() {
        
        var sut: CardCell!
        
        beforeEach {
            sut = CardCell()
        }
        
        afterEach {
            sut = nil
        }
        
        describe("CardCell") {
            context("when binding to view model") {
                it("should store correctly") {
                    // Arrange
                    let card = Card(id: "id", name: "name", imageURL: nil, imageData: UIImage(named: "backgroundImage")?.pngData(), isFavorite: false, types: [])
                    let viewModel = CardCellViewModel(card: card)
                    
                    // Act
                    sut.bind(to: viewModel)
                    
                    // Assert
                    expect(sut.viewModel).to(equal(viewModel))
                }
            }
        }
    }
}

extension CardCellViewModel: Equatable {
    public static func == (lhs: CardCellViewModel, rhs: CardCellViewModel) -> Bool {
        return lhs.card == rhs.card && lhs.imageURL == rhs.imageURL
    }
}
