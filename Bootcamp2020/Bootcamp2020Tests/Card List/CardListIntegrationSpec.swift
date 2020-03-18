//
//  CardListIntegrationSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Quick
import Nimble
import KIF
@testable import Bootcamp2020

class CardListIntegrationSpec: QuickSpec {
    
    override func spec() {
        
        var viewController: CardListViewController!
        var screen: CardListScreen!
        var service: NetworkServiceStub!
        var dataSource: CardListDataSource!
        var delegate: CardListDelegate!
        var window: UIWindow!
        
        beforeEach {
            
            service = NetworkServiceStub()
            dataSource = CardListDataSource()
            delegate = CardListDelegate()
            screen = CardListScreen(dataSource: dataSource, delegate: delegate)
            viewController = CardListViewController(service: service, screen: screen)
            window = UIWindow(frame: UIScreen.main.bounds)
            
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            _ = viewController.view
        }
        
        afterEach {
            service = nil
            dataSource = nil
            screen = nil
            viewController = nil
            window = nil
        }
        
        describe("CardList") {
            context("when loaded") {
                it("should display the correct views") {
                    self.tester.waitForView(withAccessibilityLabel: "listCollectionView")
                    self.tester.waitForView(withAccessibilityLabel: "CardListScreen")
                    self.tester.waitForView(withAccessibilityLabel: "backgroundImageView")
                    self.tester.waitForView(withAccessibilityLabel: "listSearchBar")
                }
            }
        }
    }
}
