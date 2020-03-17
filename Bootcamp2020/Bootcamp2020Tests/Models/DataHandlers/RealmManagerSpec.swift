//
//  RealmManagerSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//
// swiftlint:disable force_try

@testable import Bootcamp2020
import RealmSwift
import Quick
import Nimble

class RealmManagerSpec: QuickSpec {
    
    override func spec() {
        describe("RealmManager") {
            var sut: RealmManager!
            var config: Realm.Configuration!
            
            beforeSuite {
                config = Realm.Configuration(inMemoryIdentifier: "Bootcamp2020Test")
                sut = RealmManager(configuration: config)
            }
            
            beforeEach {
                try! sut.realm?.write {
                    sut.realm?.deleteAll()
                }
            }
            
            context("when it's initialized") {
                it("should have the given configuration") {
                    expect(sut.realm?.configuration.inMemoryIdentifier).to(equal(config.inMemoryIdentifier))
                    expect(sut.realm?.configuration.fileURL).to(beNil())
                }
            }
            
            context("when it's perfomed fetch") {
                var collection: Collection!
                var card: Card!
                
                beforeEach {
                    collection = Collection(id: "0", name: "Collection1")
                    card = Card(id: "0", name: "Card1")
                    collection.cards.append(card)
                    
                    try! sut.realm?.write {
                        sut.realm?.add(collection)
                        sut.realm?.add(card)
                    }
                }
                
                it("should return an array of collection") {
                    sut.fetchCollections { (result) in
                        switch result {
                        case .success(let collections):
                            expect(collections[0].id).to(equal(collection.id))
                        case .failure(let error):
                            expect(error).to(beAnInstanceOf(Error.self))
                            
                        }
                    }
                }
                
                it("should return an array of cards containing a given name") {
                    
                }
                
            }
            
            context("when it's saved card") {
                it("should save the given card") {
                    let card = Card(id: "0", name: "Card1")
                    let saveReturn = sut.save(card)
                    
                    if let saveReturn = saveReturn {
                        expect(saveReturn).to(beAnInstanceOf(Error.self))
                    } else {
                        let cards = sut.realm?.objects(Card.self)
                        expect(cards?.count).to(equal(1))
                    }
                }
            }
        }
        
    }
}
