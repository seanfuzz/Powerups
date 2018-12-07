//
//  CollectionCell.swift
//  Powerups
//
//  Created by Sean Orelli on 11/30/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit


class CollectionCell: UICollectionViewCell {
    
    func setup(row: CollectionItem) {
        let label = UILabel()
        contentView.addSubview(label)
        label.text = row.title
        label.textAlignment = .center
        label.pin()
    }
    
}
