//
//  CollectionView.swift
//  Powerups
//
//  Created by Sean Orelli on 11/30/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {
    
    var model: CollectionModel? {
        didSet{
            delegate = model
            dataSource = model
            if let model = model{
               register(CollectionCell.self, forCellWithReuseIdentifier: model.cellIdentifier)
            }
        }
    }
    
    override func design() {
       // separatorStyle = .none
        backgroundColor = UIColor.backgroundColor
    }

}
