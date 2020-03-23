//
//  DismissCardDetailDelegateSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 23/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class DismissCardDetailDelegateSpec: QuickSpec {
    override func spec() {
        
        describe("DismissCardDetailDelegate") {
            
            var navigationControllerSpy: UINavigationControllerSpy!
            var sut: DismissCardDetailDelegate!
            
            beforeEach {
                navigationControllerSpy = UINavigationControllerSpy()
                sut = CoordinatorSpy(rootController: navigationControllerSpy)
            }
            
            context("when dismiss it's called") {
                it("should dismiss detail modal") {
                    sut.dismissDetail(animated: true)
                    
                    expect(navigationControllerSpy.dismissWasCalled).to(beTrue())
                }
            }
        }
    }
}


//protocol DismissCardDetailDelegate: AnyObject {
//
//    func dismissDetail(animated: Bool)
//}
//
//extension DismissCardDetailDelegate where Self: Coordinator {
//
//    func dismissDetail(animated: Bool = true) {
//        rootController.dismiss(animated: animated, completion: nil)
//    }
//}
