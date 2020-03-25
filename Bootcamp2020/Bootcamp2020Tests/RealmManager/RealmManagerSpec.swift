//
//  RealmManagerSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//
// swiftlint:disable function_body_length force_try cyclomatic_complexity

@testable import Bootcamp2020
import RealmSwift
import Quick
import Nimble

final class RealmManagerSpec: QuickSpec {
    
    override func spec() {
        describe("RealmManager") {
            var sut: RealmManager!
            var config: Realm.Configuration!

            beforeSuite {
                config = Realm.Configuration(inMemoryIdentifier: "Bootcamp2020Test")
                sut = try! RealmManager(configuration: config)
            }

            beforeEach {
                try! sut.realm.write {
                    sut.realm.deleteAll()
                }
            }

            context("when it's initialized") {
                it("should have the given configuration") {
                    expect(sut.realm.configuration.inMemoryIdentifier).to(equal(config.inMemoryIdentifier))
                    expect(sut.realm.configuration.fileURL).to(beNil())
                }
            }

            context("when it's perfomed fetch") {
                var cardSet: CardSet!
                var card: Card!

                beforeEach {
                    card = Card(id: "0", name: "Card1", cardSetID: "0")
                    cardSet = CardSet(id: "0", name: "CardSet1", cards: [card])
                    
                    let realmSet = RealmCardSet(set: cardSet)
                    let realmCard = RealmCard(card: card)
                    
                    try! sut.realm.write {
                        sut.realm.add(realmSet)
                        realmSet.cards.append(realmCard)
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
                        sut.fetchCards(withName: "Collection") { (result) in
                            switch result {
                            case .success(let cards):
                                expect(cards).to(beEmpty())
                            case .failure(let error):
                                expect(error).to(beAnInstanceOf(Error.self))

                            }
                        }
                    }

                    it("should return an array with one card") {
                        sut.fetchCards(withName: "Card") { (result) in
                            switch result {
                            case .success(let cards):
                                expect(cards.count).to(equal(1))
                            case .failure(let error):
                                expect(error).to(beAnInstanceOf(Error.self))

                            }
                        }
                    }
                }
                
                context("when fetch cards of set") {
                    it("should return an array with one card") {
                        sut.fetchCards(ofSet: cardSet) { (result) in
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

            context("when card it's favorited") {
                var cardSet: CardSet!
                var card: Card!

                beforeEach {
                    cardSet = CardSet(id: "0", name: "CardSet1")
                }

                it("should favorite the given card") {
                    card = Card(id: "0", name: "Card1", cardSetID: "0", isFavorite: true)
                    let favoriteReturn = sut.toggleFavorite(card, of: cardSet)

                    guard favoriteReturn == nil else {
                        Nimble.fail()
                        return
                    }

                    let cards = sut.realm.objects(RealmCard.self)
                    expect(cards.count).to(equal(1))
                }
                
                it("should favorite card of an existing set") {
                    card = Card(id: "0", name: "Card1", cardSetID: "0", isFavorite: true)
                    let newCard = Card(id: "1", name: "Card2", cardSetID: "0", isFavorite: true)
                    
                    _ = sut.toggleFavorite(card, of: cardSet)
                    let favoriteReturn = sut.toggleFavorite(newCard, of: cardSet)
                    
                    guard favoriteReturn == nil else {
                        Nimble.fail()
                        return
                    }
                    
                    let cards = sut.realm.objects(RealmCard.self)
                    expect(cards.count).to(equal(2))
                }

                it("should unfavorite the given card") {
                    card = Card(id: "0", name: "Card1", cardSetID: "0", isFavorite: true)
                    _ = sut.toggleFavorite(card, of: cardSet)
                    card.isFavorite = false
                    let unfavoriteReturn = sut.toggleFavorite(card, of: cardSet)

                    guard unfavoriteReturn == nil else {
                        Nimble.fail()
                        return
                    }

                    let cards = sut.realm.objects(RealmCard.self)
                    expect(cards.count).to(equal(0))
                }
            }

            context("when checked if card it's favorite") {
                var cardSet: CardSet!
                var card: Card!

                beforeEach {
                    cardSet = CardSet(id: "0", name: "CardSet1")
                }

                it("should return true") {
                    card = Card(id: "0", name: "Card1", cardSetID: "0", isFavorite: true)

                    if sut.toggleFavorite(card, of: cardSet) != nil {
                        Nimble.fail()
                    }

                    expect(sut.isFavorite(card)).to(beTrue())
                }

                it("should return false") {
                    card = Card(id: "0", name: "Card1", cardSetID: "0", isFavorite: false)

                    expect(sut.isFavorite(card)).to(beFalse())
                }
            }
        }
    }
}
