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
    
    // MARK: - Init -
    init(service: Service,
         screen: CardListScreen = CardListScreen()) {
        
        self.service = service
        self.listScreen = screen
        
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
                self.sets.append(contentsOf: cardSets)
                
                guard let firstSet = self.sets.first else { return }
                DispatchQueue.main.async {
                    self.service.fetchCards(ofSet: firstSet) { [weak self, weak firstSet] (result) in
                        
                        guard let `self` = self else { return }
                        switch result {
                        case .success(let cards):
                            firstSet?.cards.append(objectsIn: cards)
                            self.listScreen.bind(to: CardListViewModel(state: .success(self.sets), delegate: self))
                        case .failure(let error):
                            debugPrint(error.localizedDescription)
                            self.listScreen.bind(to: CardListViewModel(state: .error, delegate: self))
                        }
                    }
                }
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self.listScreen.bind(to: CardListViewModel(state: .error, delegate: self))
            }
        }
    }
}

extension CardListViewController: CardListViewModelDelegate {
    func didSet(_ state: CardListViewModel.UIState) {
        listScreen.bind(to: CardListViewModel(state: state, delegate: self))
    }
    
    func didSelect(_ card: Card) {
        
        // TODO: Call coordinator delegate
        
    }
}
