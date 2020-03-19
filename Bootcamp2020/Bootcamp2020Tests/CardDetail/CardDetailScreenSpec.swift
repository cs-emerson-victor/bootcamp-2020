//
//  CardDetailScreenSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//
//swiftlint:disable function_body_length

import Quick
import Nimble
@testable import Bootcamp2020

final class CardDetailScreenSpec: QuickSpec {
    
    override func spec() {
        
        var dataSource: CardDetailDataSource!
        var delegate: CardDetailDelegate!
        var sut: CardDetailScreen!
        
        beforeEach {
            
            dataSource = CardDetailDataSource()
            delegate = CardDetailDelegate()
            sut = CardDetailScreen(dataSource: dataSource, delegate: delegate)
        }
        
        afterEach {
            sut = nil
            dataSource = nil
            delegate = nil
        }
        
        describe("CardDetailScreen") {
            context("when initialized") {
                it("should have added its subviews") {
                    
                    // Act
                    var hasCloseButton = false
                    var hasFavoriteButton = false
                    var hasCollectionView = false
                    var hasBackgroundImageView = false
                    for view in sut.subviews {
                        switch view.accessibilityLabel {
                        case "cardDetailCollectionView":
                            hasCollectionView = true
                        case "detailBackgroundImageView":
                            hasBackgroundImageView = true
                        case "favoriteButton":
                            hasFavoriteButton = true
                        case "closeButton":
                            hasCloseButton = true
                        default:
                            break
                        }
                    }
                    
                    // Assert
                    expect(hasBackgroundImageView).to(beTrue())
                    expect(hasCollectionView).to(beTrue())
                    expect(hasFavoriteButton).to(beTrue())
                    expect(hasCloseButton).to(beTrue())
                }
                
                it("should have the correct given objects") {
                    
                    expect(sut.cardDetailDataSource).to(beIdenticalTo(dataSource))
                    expect(sut.cardDetailDelegate).to(beIdenticalTo(delegate))
                }
            }
            
            context("when receiving a view model") {
                it("should bind correctly") {
                    // Act
                    let viewModel = CardDetailViewModel(cards: [], delegate: CardDetailViewModelDelegateDummy())
                    sut.bind(to: viewModel)
                    // Assert
                    expect(sut.viewModel).to(equal(viewModel))
                }
            }
        }
    }
}

extension CardDetailViewModel: Equatable {
    public static func == (lhs: CardDetailViewModel, rhs: CardDetailViewModel) -> Bool {
        return lhs.cards == rhs.cards
    }
}
