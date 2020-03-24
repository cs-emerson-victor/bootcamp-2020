//
//  AppCoordinatorSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//
// swiftlint:disable function_body_length

@testable import Bootcamp2020
import Quick
import Nimble

final class AppCoordinatorSpec: QuickSpec {

    override func spec() {
        describe("AppCoordinator") {
            var window: UIWindow!
            var rootController: UINavigationController!
            var localService: LocalService!
            var networkService: Service!
            
            beforeEach {
                window = UIWindow()
                rootController = UINavigationController()
                localService = LocalServiceDummy()
                networkService = NetworkServiceDummy()
            }
            
            context("when it's initialized") {
                var sut: AppCoordinator!
                
                it("should have the given objects") {
                    sut = AppCoordinator(presenter: window,
                                         rootController: rootController,
                                         localService: localService,
                                         networkService: networkService)
                    
                    expect(sut.presenter).to(beIdenticalTo(window))
                    expect(sut.rootController).to(beIdenticalTo(rootController))
                    expect(rootController.isNavigationBarHidden).to(equal(true))
                    expect(sut.tabBar).to(beAnInstanceOf(UITabBarController.self))
                    expect(sut.localService).to(beIdenticalTo(localService))
                    expect(sut.networkService).to(beIdenticalTo(networkService))
                    expect(sut.childCoordinators).to(beEmpty())
                }
                
                it("should initialize the local service") {
                    sut = AppCoordinator(presenter: window,
                                         rootController: rootController,
                                         networkService: networkService)
                    
                    expect(sut.presenter).to(beIdenticalTo(window))
                    expect(sut.rootController).to(beIdenticalTo(rootController))
                    expect(rootController.isNavigationBarHidden).to(equal(true))
                    expect(sut.tabBar).to(beAnInstanceOf(UITabBarController.self))
                    expect(sut.networkService).to(beIdenticalTo(networkService))
                    expect(sut.childCoordinators).to(beEmpty())
                    expect(sut.localService).to(beAnInstanceOf(RealmManager.self))
                }
            }
            
            context("when it's started") {
                var sut: AppCoordinatorSpy!
                
                it("should have the correct child coordinators and the given root controller") {
                    sut = AppCoordinatorSpy(presenter: window,
                                            rootController: rootController,
                                            localService: localService,
                                            networkService: networkService)
                    sut.start()
                    
                    expect(sut.childCoordinators[0]).to(beAnInstanceOf(HomeCoordinator.self))
                    expect(sut.childCoordinators[1]).to(beAnInstanceOf(FavoritesCoordinator.self))
                    expect(sut.tabBar.viewControllers?.count).to(equal(2))
                    expect(sut.presenter.rootViewController).to(beIdenticalTo(rootController))
                    expect(sut.presenter.isHidden).to(equal(false))
                }
                
                it("should have the correct root controlle and present initializationError") {
                    sut = AppCoordinatorSpy(presenter: window,
                                            rootController: rootController,
                                            localService: nil,
                                            networkService: networkService)
                    
                    sut.start()
                    
                    expect(sut.presenter.rootViewController).to(beAnInstanceOf(UIViewController.self))
                    expect(sut.presenter.isHidden).to(equal(false))
                    expect(sut.presentInitializationErrorWasCalled).to(beTrue())
                }
            }
            
            context("when initialization error it's presented") {
                var controllerSpy: ViewControllerSpy!
                var sut: AppCoordinator!
                
                beforeEach {
                    controllerSpy = ViewControllerSpy()
                }
                
                it("should present alert") {
                    sut = AppCoordinator(presenter: window,
                                         rootController: rootController,
                                         localService: nil,
                                         networkService: networkService)
                    
                    sut.presentInitializationError(in: controllerSpy)
                    
                    expect(controllerSpy.presentWasCalled).to(beTrue())
                }
            }
        }
    }
}
