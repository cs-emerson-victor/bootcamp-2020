//
//  CoordinatorSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 23/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class CoordinatorSpec: QuickSpec {
    override func spec() {
        
        describe("Coordinator") {
            var child: Coordinator!
            var sut: Coordinator!
            
            beforeEach {
                child = CoordinatorSpy()
                sut = CoordinatorSpy()
            }
            
            context("when added child coordinator") {
                it("should have one child coordinator") {
                    sut.add(child)
                    
                    expect(sut.childCoordinators.count).to(equal(1))
                }
            }
            
            context("when removed child coordinators") {
                it("should have zero childs coordinators") {
                    sut.childCoordinators.append(child)
                    sut.remove(child)
                    
                    expect(sut.childCoordinators).to(beEmpty())
                }
            }
        }
    }
}
