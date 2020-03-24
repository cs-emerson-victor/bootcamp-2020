//
//  CardListScreenSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//
//swiftlint:disable function_body_length

import Quick
import Nimble
import UIKit
@testable import Bootcamp2020

final class CardListScreenSpec: QuickSpec {
    
    override func spec() {
        
        var dataSource: CardListDataSource!
        var delegate: CardListDelegate!
        var sut: CardListScreen!
        
        beforeEach {
            
            dataSource = CardListDataSource()
            delegate = CardListDelegate()
            sut = CardListScreen(dataSource: dataSource, delegate: delegate)
        }
        
        afterEach {
            sut = nil
            dataSource = nil
            delegate = nil
        }
        
        describe("CardListScreen") {
            context("when initialized") {
                it("should have added its subviews") {
                    
                    // Act
                    var searchBar: UISearchBar?
                    var hasCollectionView = false
                    var hasBackgroundImageView = false
                    var hasActivityIndicator = false
                    for view in sut.subviews {
                        switch view.accessibilityLabel {
                        case "listCollectionView":
                            hasCollectionView = true
                        case "listSearchBar":
                            searchBar = view as? UISearchBar
                        case "backgroundImageView":
                            hasBackgroundImageView = true
                        case "activityIndicator":
                            hasActivityIndicator = true
                        default:
                            break
                        }
                    }
                    
                    // Assert
                    expect(hasBackgroundImageView).to(beTrue())
                    expect(hasActivityIndicator).to(beTrue())
                    expect(hasCollectionView).to(beTrue())
                    expect(searchBar).notTo(beNil())
                    expect(searchBar?.delegate).to(be(sut))
                }
                
                it("should have the correct given objects") {
                    
                    expect(sut.cardDataSource).to(beIdenticalTo(dataSource))
                    expect(sut.cardDelegate).to(beIdenticalTo(delegate))
                }
            }
            
            context("when receiving a view model") {
                it("should bind correctly") {
                    // Arrange
                    let cardSets = CardSetStub().getEmptySets()
                    // Act
                    let viewModel = CardListViewModel(state: .loading(cardSets), delegate: CardListViewController(service: NetworkServiceDummy()))
                    sut.bind(to: viewModel)
                    // Assert
                    expect(sut.viewModel).to(equal(viewModel))
                }
                
                context("of initial loading state") {
                    it("should display the activity indicator") {
                        
                        // Arrange
                        var activityIndicator: UIActivityIndicatorView!
                        for case let view as UIActivityIndicatorView in sut.subviews where view.accessibilityLabel == "activityIndicator" {
                            activityIndicator = view
                            break
                        }
                        
                        // Act
                        let viewModel = CardListViewModel(state: .initialLoading, delegate: CardListViewModelDelegateDummy())
                        sut.bind(to: viewModel)
                        
                        // Assert
                        expect(activityIndicator.isAnimating).to(beTrue())
                    }
                }
                
                context("of error state") {
                    it("should display the error view") {
                        
                        // Act
                        let viewModel = CardListViewModel(state: .error(.generic), delegate: CardListViewModelDelegateDummy())
                        sut.bind(to: viewModel)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            var errorView: ErrorView?
                            for case let view as ErrorView in sut.subviews {
                                errorView = view
                                break
                            }
                            
                            // Assert
                            expect(errorView).toNot(beNil())
                            expect(errorView?.superview).toNot(beNil())
                        }
                    }
                }
                
                context("of success state") {
                    it("should pass the card sets and cell function to the data source") {
                        
                        // Arrange
                        let cardSets = CardSetStub().getEmptySets()
                        
                        // Act
                        let viewModel = CardListViewModel(state: .success(cardSets), delegate: CardListViewModelDelegateDummy())
                        sut.bind(to: viewModel)
                        
                        // Assert
                        expect(dataSource.getViewModel).toNot(beNil())
                        expect(dataSource.sets).to(equal(cardSets))
                    }
                    
                    it("should pass the selection function ") {
                        
                        // Arrange
                        let cardSets = CardSetStub().getEmptySets()
                        
                        // Act
                        let viewModel = CardListViewModel(state: .success(cardSets), delegate: CardListViewModelDelegateDummy())
                        sut.bind(to: viewModel)
                        
                        // Assert
                        expect(delegate.didSelectItemAt).toNot(beNil())
                    }
                }
            }
        }
    }
}

extension CardListViewModel: Equatable {
    public static func == (lhs: CardListViewModel, rhs: CardListViewModel) -> Bool {
        return lhs.cardSets == rhs.cardSets && lhs.state == rhs.state
    }
}
