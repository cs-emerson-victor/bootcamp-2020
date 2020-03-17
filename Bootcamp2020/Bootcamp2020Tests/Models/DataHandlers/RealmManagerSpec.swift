//
//  RealmManagerSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//
// swiftlint:disable function_body_length force_try

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
                var cardSet: CardSet!
                var card: Card!
                
                beforeEach {
                    cardSet = CardSet(id: "0", name: "CardSet1")
                    card = Card(id: "0", name: "Card1")
                    cardSet.cards.append(card)
                    
                    try! sut.realm?.write {
                        sut.realm?.add(cardSet)
                        sut.realm?.add(card)
                    }
                }
                
                it("should return an array with one set") {
                    sut.fetchSets { (result) in
                        switch result {
                        case .success(let cardSets):
                            expect(cardSets.count).to(equal(1))
                        case .failure(let error):
                            expect(error).to(beAnInstanceOf(Error.self))
                            
                        }
                    }
                }
                
                context("when it's fetched by name") {
                    it("should return an empty array") {
                        sut.fetchCard(withName: "Collection") { (result) in
                            switch result {
                            case .success(let cards):
                                expect(cards).to(beEmpty())
                            case .failure(let error):
                                expect(error).to(beAnInstanceOf(Error.self))
                                
                            }
                        }
                    }
                    
                    it("should return an array with one card") {
                        sut.fetchCard(withName: "Card") { (result) in
                            switch result {
                            case .success(let cards):
                                expect(cards.count).to(equal(1))
                            case .failure(let error):
                                expect(error).to(beAnInstanceOf(Error.self))
                                
                            }
                        }
                    }
                    
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
