
//
//  TableItem.swift
//  Powerups
//
//  Created by Sean Orelli on 12/6/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit


/*_____________________________________________
 
                Table Item
 _____________________________________________*/
@objc class CollectionItem: NSObject, CollectionItemProvider {
    
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var width: CGFloat = 100
    var height: CGFloat = 100
    var emoji: String?
    var cellIdentifier: String { return "CollectionCell" }
    
    var autoDeselct = true
    var selectedAction: Closure<IndexPath>?
    var deselectedAction: Block?
    
    var collectionItem: CollectionItem { return self }
    var pickerElements: [String]?
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
/*
    func cell(collectionView: UICollectionView) -> CollectionCell {
        let cell = CollectionCell()
        cell.backgroundColor = .gray(1)
        cell.contentView.backgroundColor = .gray(1)
        return cell
    }*/

    func cell(collectionView: UICollectionView, indexPath:IndexPath) -> CollectionCell
    {
        
        let cell = CollectionCell()
        cell.backgroundColor = .gray(1)
        cell.contentView.backgroundColor = .gray(1)
        return cell
    }

}


protocol CollectionItemProvider {
    var collectionItem: CollectionItem { get }
}


extension String: CollectionItemProvider {
    
    var collectionItem: CollectionItem {
        let item = CollectionItem()
        item.title = self
        return item
    }
}
