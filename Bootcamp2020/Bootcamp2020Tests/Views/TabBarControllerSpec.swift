//
//  TabBarControllerSpec.swift
//  Bootcamp2020Tests
//
//  Created by jacqueline alves barbosa on 25/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Quick
import Nimble
@testable import Bootcamp2020

final class TabBarControllerSpec: QuickSpec {
    override func spec() {
        var sut: TabBarController!
        
        beforeEach {
            sut = TabBarController()
        }
    
        afterEach {
            sut = nil
        }
        
        describe("TabBarControllerSpec") {
            context("when initialized") {
                it("should have the expected look") {
                    expect(sut.tabBar.barTintColor).to(be(UIColor.black))
                    expect(sut.tabBar.isTranslucent).to(be(false))
                    expect(sut.tabBar.tintColor).to(equal(UIColor(red: 0.92, green: 0.60, blue: 0.18, alpha: 1.00)))
                }
            }
        }
    }
}
