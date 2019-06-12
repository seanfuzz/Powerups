//
//  CollectionCell.swift
//  Powerups
//
//  Created by Sean Orelli on 11/30/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit


class CollectionCell: UICollectionViewCell
{
    let label = UILabel()

    func setup(row: CollectionItem)
    {
        contentView.addSubview(label)
        label.numberOfLines = 3
        label.text = row.title
        label.textAlignment = .center
        label.pin()
        label.backgroundColor = .gray(0)
    }
    
}
