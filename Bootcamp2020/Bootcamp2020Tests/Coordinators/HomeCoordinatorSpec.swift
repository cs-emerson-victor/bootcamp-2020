//
//  HomeCoordinatorSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

class HomeCoordinatorSpec: QuickSpec {
    
    override func spec() {
        describe("HomeCoordinator") {
            var rootController: UINavigationController!
            var service: Service!
            var homeCoordinator: HomeCoordinator!
            
            beforeEach {
                rootController = UINavigationController()
                service = LocalServiceDummy()
                homeCoordinator = HomeCoordinator(rootController: rootController,
                                                  service: service)
            }
            
            context("when it's initialized") {
                it("should have the given objects") {
                    expect(homeCoordinator.rootController).to(beIdenticalTo(rootController))
                    expect(homeCoordinator.childCoordinators).to(beEmpty())
                    expect(homeCoordinator.service).to(beIdenticalTo(service))
                }
            }
            
            context("when it's started") {
                it("should have the correct tab bar item and push the correct controller") {
                    homeCoordinator.start()
                    let controllers = homeCoordinator.rootController.viewControllers
                    
                    expect(controllers.count).to(equal(1))
                    expect(controllers[0].tabBarItem.tag).to(equal(0))
                }
            }
        }
    }
}
