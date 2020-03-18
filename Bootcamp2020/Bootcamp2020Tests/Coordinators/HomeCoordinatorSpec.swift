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
            var sut: HomeCoordinator!
            
            beforeEach {
                rootController = UINavigationController()
                service = LocalServiceDummy()
                sut = HomeCoordinator(rootController: rootController,
                                                  service: service)
            }
            
            context("when it's initialized") {
                it("should have the given objects") {
                    expect(sut.rootController).to(beIdenticalTo(rootController))
                    expect(sut.rootController.isNavigationBarHidden).to(equal(true))
                    expect(sut.childCoordinators).to(beEmpty())
                    expect(sut.service).to(beIdenticalTo(service))
                }
            }
            
            context("when it's started") {
                it("should have the correct tab bar item and push the correct controller") {
                    sut.start()
                    let controllers = sut.rootController.viewControllers
                    
                    expect(controllers.count).to(equal(1))
                    expect(controllers[0].tabBarItem.tag).to(equal(0))
                }
            }
        }
    }
}
