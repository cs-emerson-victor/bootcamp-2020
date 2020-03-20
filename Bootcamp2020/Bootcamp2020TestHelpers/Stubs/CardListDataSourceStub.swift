//
//  CardListDataSourceStub.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit
@testable import Bootcamp2020

final class CardListDataSourceStub: NSObject, UICollectionViewDataSource {
    
    var items: [String] = {
        return (0...10).map { String($0) }
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        return cell
    }
}
