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
            var appCoordinator: AppCoordinator!
            
            beforeEach {
                window = UIWindow()
                rootController = UINavigationController()
                localService = LocalServiceDummy()
                networkService = NetworkServiceDummy()
                appCoordinator = AppCoordinator(presenter: window,
                                                rootController: rootController,
                                                localService: localService,
                                                networkService: networkService)
            }
            
            context("when it's initialized") {
                it("should have the given objects") {
                    expect(appCoordinator.presenter).to(beIdenticalTo(window))
                    expect(appCoordinator.rootController).to(beIdenticalTo(rootController))
                    expect(rootController.isNavigationBarHidden).to(equal(true))
                    expect(appCoordinator.tabBar).to(beAnInstanceOf(UITabBarController.self))
                    expect(appCoordinator.localService).to(beIdenticalTo(localService))
                    expect(appCoordinator.networkService).to(beIdenticalTo(networkService))
                    expect(appCoordinator.childCoordinators).to(beEmpty())
                }
            }
            
            context("when it's started") {
                it("should have the correct child coordinators and the given root controller") {
                    appCoordinator.start()
                    
                    expect(appCoordinator.childCoordinators[0]).to(beAnInstanceOf(HomeCoordinator.self))
                    expect(appCoordinator.childCoordinators[1]).to(beAnInstanceOf(FavoritesCoordinator.self))
                    expect(appCoordinator.tabBar.viewControllers?.count).to(equal(2))
                    expect(appCoordinator.presenter.rootViewController).to(beIdenticalTo(rootController))
                    expect(appCoordinator.presenter.isHidden).to(equal(false))
                }
            }
        }
    }
}
