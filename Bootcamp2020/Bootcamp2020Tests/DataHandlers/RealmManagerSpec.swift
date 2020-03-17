//
//  RealmManagerSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import RealmSwift
import Quick
import Nimble

class RealmManagerSpec: QuickSpec {
    
    override func spec() {
        describe("RealmManager") {
            var sut: RealmManager!
            var realm: Realm!
            
            beforeSuite {
                let config = Realm.Configuration(inMemoryIdentifier: "Bootcamp2020Test")
                sut = RealmManager(configuration: config)
            }
            
            beforeEach {
              realm = try! Realm()
              try! realm.write {
                realm.deleteAll()
              }
            }
            
            context("when it's perfomed fetch") {
                it("should return an array of collection") {
                    
                }
                
                it("should return an array of cards containing a given name") {
                    
                }
                
            }
            
            context("when it's saved card") {
                it("should save the given card") {
                    
                    
                }
            }
        }
        
    }
}
