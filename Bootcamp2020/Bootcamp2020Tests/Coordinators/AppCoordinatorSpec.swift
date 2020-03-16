//
//  AppCoordinatorSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

class AppCoordinatorSpec: QuickSpec {

    override func spec() {
        describe("AppCoordinator") {
            var window: UIWindow!
            var rootController: UINavigationController!
            var localService: LocalService!
            var networkService: NetworkService!
            var sut: AppCoordinator!
            
            beforeEach {
                window = UIWindow()
                rootController = UINavigationController()
                localService = LocalServiceDummy()
                networkService = NetworkServiceDummy()
                sut = AppCoordinator(presenter: window,
                                                rootController: rootController,
                                                localService: localService,
                                                networkService: networkService)
            }
            
            context("when it's initialized") {
                it("should have the given objects") {
                    expect(sut.presenter).to(beIdenticalTo(window))
                    expect(sut.rootController).to(beIdenticalTo(rootController))
                    expect(rootController.isNavigationBarHidden).to(equal(true))
                    expect(sut.tabBar).to(beAnInstanceOf(UITabBarController.self))
                    expect(appCoordinator.localService).to(beIdenticalTo(localService))
                    expect(appCoordinator.networkService).to(beIdenticalTo(networkService))
                    expect(sut.childCoordinators).to(beEmpty())
                }
            }
            
            context("when it's started") {
                it("should have the correct child coordinators and the given root controller") {
                    sut.start()
                    
                    expect(appCoordinator.childCoordinators[0]).to(beAnInstanceOf(HomeCoordinator.self))
                    expect(appCoordinator.childCoordinators[1]).to(beAnInstanceOf(FavoritesCoordinator.self))
                    expect(sut.tabBar.viewControllers?.count).to(equal(2))
                    expect(sut.presenter.rootViewController).to(beIdenticalTo(rootController))
                    expect(sut.presenter.isHidden).to(equal(false))
                }
            }
        }
    }
}
