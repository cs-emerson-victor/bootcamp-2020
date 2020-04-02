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
        var viewModelDelegate: CardListViewModelDelegateDummy!
        var sut: CardListScreen!
        
        beforeEach {
            
            dataSource = CardListDataSource()
            delegate = CardListDelegate()
            viewModelDelegate = CardListViewModelDelegateDummy()
            sut = CardListScreen(dataSource: dataSource, delegate: delegate)
        }
        
        afterEach {
            sut = nil
            dataSource = nil
            delegate = nil
            viewModelDelegate = nil
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
                        let viewModel = CardListViewModel(state: .initialLoading, delegate: viewModelDelegate)
                        sut.bind(to: viewModel)
                        
                        // Assert
                        expect(activityIndicator.isAnimating).to(beTrue())
                    }
                }
                
                context("of error state") {
                    it("should display the error view") {
                        
                        // Act
                        let viewModel = CardListViewModel(state: .error(.generic), delegate: viewModelDelegate)
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
                    it("should pass the dataSource protocol") {
                        
                        // Arrange
                        let cardSets = CardSetStub().getEmptySets()
                        
                        // Act
                        let viewModel = CardListViewModel(state: .success(cardSets), delegate: viewModelDelegate)
                        sut.bind(to: viewModel)
                        
                        // Assert
                        expect(dataSource.dataSourceProtocol).toNot(beNil())
                    }
                    
                    it("should pass the delegate protocol") {
                        
                        // Arrange
                        let cardSets = CardSetStub().getEmptySets()
                        
                        // Act
                        let viewModel = CardListViewModel(state: .success(cardSets), delegate: viewModelDelegate)
                        sut.bind(to: viewModel)
                        
                        // Assert
                        expect(delegate.delegateProtocol).toNot(beNil())
                    }
                }
            }
            
            context("when checking loading state") {
                var viewModel: CardListViewModel!
                
                afterEach {
                    viewModel = nil
                }
                
                it("should return true if state is loading") {
                    viewModel = CardListViewModel(state: .loading([]), delegate: viewModelDelegate)
                    
                    sut.bind(to: viewModel)
                    
                    expect(sut.isLoading).to(beTrue())
                }
                
                it("should return true if state is searching") {
                    viewModel = CardListViewModel(state: .searching, delegate: viewModelDelegate)
                    
                    sut.bind(to: viewModel)
                    
                    expect(sut.isLoading).to(beTrue())
                }
                
                it("should return true if state is initialLoading") {
                    viewModel = CardListViewModel(state: .initialLoading, delegate: viewModelDelegate)
                    
                    sut.bind(to: viewModel)
                   
                    expect(sut.isInitialLoading).to(beTrue())
                }
                
                it("should return false if state is error") {
                    viewModel = CardListViewModel(state: .error(.generic), delegate: viewModelDelegate)
                    
                    sut.bind(to: viewModel)
                    
                    expect(sut.isLoading).to(beFalse())
                    expect(sut.isInitialLoading).to(beFalse())
                }
                
                it("should return false if state is success") {
                    viewModel = CardListViewModel(state: .success([]), delegate: viewModelDelegate)
                   
                    sut.bind(to: viewModel)
                   
                    expect(sut.isLoading).to(beFalse())
                    expect(sut.isInitialLoading).to(beFalse())
                }
                
                it("should return false if state is success") {
                    viewModel = CardListViewModel(state: .searchSuccess([]), delegate: viewModelDelegate)
                   
                    sut.bind(to: viewModel)
                   
                    expect(sut.isLoading).to(beFalse())
                    expect(sut.isInitialLoading).to(beFalse())
                }
                
                it("should return false if view model is nil") {
                    expect(sut.isLoading).to(beFalse())
                    expect(sut.isInitialLoading).to(beFalse())
                }
            }
        }
        
        context("when binding view model") {
            var viewModel: CardListViewModel!
            
            afterEach {
                viewModel = nil
            }
            
            it("should change to initial loading state") {
                viewModel = CardListViewModel(state: .initialLoading, delegate: viewModelDelegate)
                
                sut.bind(to: viewModel)
                
                DispatchQueue.main.async {
                    expect(sut.searchBar.isUserInteractionEnabled).to(beFalse())
                    expect(sut.activityIndicator.isAnimating).to(beTrue())
                }
            }
            
            it("should change to loading state") {
                viewModel = CardListViewModel(state: .initialLoading, delegate: viewModelDelegate)
                
                sut.bind(to: viewModel)
                
                DispatchQueue.main.async {
                    expect(sut.activityIndicator.isAnimating).to(beTrue())
                    expect(sut.errorView.superview).to(beNil())
                }
            }
            
            it("should change to success state") {
                viewModel = CardListViewModel(state: .success([]), delegate: viewModelDelegate)
                
                sut.bind(to: viewModel)
                
                DispatchQueue.main.async {
                    expect(sut.searchBar.isUserInteractionEnabled).to(beTrue())
                    expect(sut.errorView.superview).to(beNil())
                    expect(sut.activityIndicator.isAnimating).to(beFalse())
                }
            }
            
            it("should change to search success state") {
                viewModel = CardListViewModel(state: .searchSuccess([]), delegate: viewModelDelegate)
                
                sut.bind(to: viewModel)
                
                DispatchQueue.main.async {
                    expect(sut.errorView.superview).to(beNil())
                    expect(sut.activityIndicator.isAnimating).to(beFalse())
                }
            }
            
            it("should change to searching") {
                viewModel = CardListViewModel(state: .searching, delegate: viewModelDelegate)
                
                sut.bind(to: viewModel)
                
                DispatchQueue.main.async {
                    expect(sut.errorView.superview).to(beNil())
                    expect(sut.activityIndicator.isAnimating).to(beTrue())
                }
            }
            
            it("should change to error") {
                viewModel = CardListViewModel(state: .error(.generic), delegate: viewModelDelegate)
                
                sut.bind(to: viewModel)
                
                DispatchQueue.main.async {
                    expect(sut.errorView.superview).to(be(sut))
                    expect(sut.activityIndicator.isAnimating).to(beFalse())
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
