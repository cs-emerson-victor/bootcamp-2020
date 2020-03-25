//
//  CardListViewController.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class CardListViewController: UIViewController {

    // MARK: - Properties -
    private(set) var sets: [CardSet] = []
    
    private var listScreen: CardListScreen
    var service: Service
    weak var detailDelegate: ShowCardDetailDelegate?
    
    private var canceledSearch: Bool = false
    
    // MARK: - Init -
    init(service: Service,
         screen: CardListScreen = CardListScreen(),
         detailDelegate: ShowCardDetailDelegate? = nil) {
        
        self.service = service
        self.listScreen = screen
        self.detailDelegate = detailDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods -
    
    // MARK: Lifecycle
    override func loadView() {
        
        view = listScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listScreen.bind(to: CardListViewModel(state: .initialLoading, delegate: self))
        
        service.fetchSets { [weak self] (result) in
            
            guard let `self` = self else { return }
            switch result {
            case .success(let cardSets):
                let sortedSets = self.sortSets(cardSets)
                self.sets.append(contentsOf: sortedSets)
                
                guard let firstSet = sortedSets.first else {
                    // TODO: Implement empty list screen
                    self.listScreen.bind(to: CardListViewModel(state: .error(.api), delegate: self))
                    return
                }
                DispatchQueue.main.async {
                    self.fetchCardsForSet(firstSet)
                }
                
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if service is LocalService {
            service.fetchSets { [weak self] (result) in
                guard let `self` = self else { return }
                
                switch result {
                case .success(let cardSets):
                    self.sets = self.sortSets(cardSets)
                    self.listScreen.bind(to: CardListViewModel(state: .success(self.sets), delegate: self))
                case .failure:
                    self.listScreen.bind(to: CardListViewModel(state: .error(.generic), delegate: self))
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    // MARK: Other methods
    func fetchCardsForSet(_ set: CardSet) {
        guard set.cards.isEmpty, !listScreen.isLoading else {
            self.listScreen.bind(to: CardListViewModel(state: .success(self.sets), delegate: self))
            return
        }
        listScreen.bind(to: CardListViewModel(state: .loading(sets), delegate: self))
        
        service.fetchCards(ofSet: set) { [weak self, weak set] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let cards):
                set?.cards.append(contentsOf: cards)
                self.listScreen.bind(to: CardListViewModel(state: .success(self.sets), delegate: self))
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    func searchCard(withName name: String) {
        guard !listScreen.isLoading else { return }

        listScreen.bind(to: CardListViewModel(state: .searching, delegate: self))
        
        service.fetchCards(withName: name) { [weak self] result in
            guard let `self` = self else { return }
            guard self.canceledSearch == false else { return }
            
            switch result {
            case .success(let cards):
                if cards.isEmpty {
                    self.listScreen.bind(to: CardListViewModel(state: .error(.emptySearch(name)), delegate: self))
                } else {
                    let cardsBySetId = self.cardsBySetId(cards)
                    let setsCopies = self.makeSetsCopies(withDictionaty: cardsBySetId)
                    let sortedSets = self.sortSets(setsCopies)
                    
                    self.listScreen.bind(to: CardListViewModel(state: .searchSuccess(sortedSets), delegate: self))
                }
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    internal func handleError(_ error: ServiceError) {
        switch error {
        case .networkError:
            self.listScreen.bind(to: CardListViewModel(state: .error(.noInternet), delegate: self))
        case .apiError:
            self.listScreen.bind(to: CardListViewModel(state: .error(.api), delegate: self))
        default:
            self.listScreen.bind(to: CardListViewModel(state: .error(.generic), delegate: self))
        }
    }
    
    internal func sortSets(_ sets: [CardSet]) -> [CardSet] {
        return sets.sorted(by: { $0.releaseDate > $1.releaseDate })
    }
    
    internal func cardsBySetId(_ cards: [Card]) -> [String: [Card]] {
        var cardsBySetId: [String: [Card]] = [:]
        
        for card in cards {
            if cardsBySetId[card.cardSetID] == nil {
                cardsBySetId[card.cardSetID] = []
            }
            
            cardsBySetId[card.cardSetID]?.append(card)
        }
        
        return cardsBySetId
    }
    
    internal func makeSetsCopies(withDictionaty dict: [String: [Card]]) -> [CardSet] {
        var setsCopies: [CardSet] = []
        
        for (setId, cards) in dict {
            guard let set = sets.first(where: { $0.id == setId }) else { continue }
            
            let sortedCards = cards.sorted(by: { $0.name < $1.name })
            let setCopy = CardSet(id: set.id,
                                  name: set.name,
                                  releaseDate: set.releaseDate,
                                  cards: sortedCards)
            
            setsCopies.append(setCopy)
        }
        
        return setsCopies
    }
}

extension CardListViewController: CardListViewModelDelegate {
    func didSet(_ state: CardListViewModel.UIState) {
        listScreen.bind(to: CardListViewModel(state: state, delegate: self))
    }
    
    func didSelect(_ card: Card, of set: CardSet) {
        detailDelegate?.show(set, selectedCardId: card.id)
    }
    
    func prefetchSet(_ set: CardSet) {
        fetchCardsForSet(set)
    }
    
    func didEnterSearchText(_ text: String) {
        canceledSearch = false
        searchCard(withName: text)
    }
    
    func didCancelSearch() {
        canceledSearch = true
        listScreen.bind(to: CardListViewModel(state: .success(sets), delegate: self))
    }
}
