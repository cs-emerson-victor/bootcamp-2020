//
//  FavoritesCoordinator.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

class FavoritesCoordinatorSpec: QuickSpec {
    
    override func spec() {
        describe("FavoritesCoordinator") {
            var rootController: UINavigationController!
            var service: Service!
            var favoritesCoordinator: FavoritesCoordinator!
            
            beforeEach {
                rootController = UINavigationController()
                service = LocalServiceDummy()
                favoritesCoordinator = FavoritesCoordinator(rootController: rootController,
                                                            service: service)
            }
            
            context("when it's initialized") {
                it("should have the given objects") {
                    expect(favoritesCoordinator.rootController).to(beIdenticalTo(rootController))
                    expect(favoritesCoordinator.childCoordinators).to(beEmpty())
                    expect(favoritesCoordinator.service).to(beIdenticalTo(service))
                }
            }
            
            context("when it's started") {
                it("should have the correct tab bar item and push the correct controller") {
                    favoritesCoordinator.start()
                    let controllers = favoritesCoordinator.rootController.viewControllers
                    
                    expect(controllers.count).to(equal(1))
                    expect(controllers[0].tabBarItem.tag).to(equal(1))
                }
            }
        }
    }
}
