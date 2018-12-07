//
//  CollectionSection.swift
//  Powerups
//
//  Created by Sean Orelli on 12/6/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

protocol CollectionSectionProvider {
    var collectionSection: CollectionSection { get }
}

/*_____________________________________________
 
 Table Section
 _____________________________________________*/
class CollectionSection: NSObject, CollectionSectionProvider {
    
    var rows = [CollectionItem]()
    var title: String?
    var open: Bool = true
    var hidden: Bool = false
    var indexName: String?
    var header: UIView?
    
    func add(item: CollectionItem){
        rows.append(item)
    }
    
    var collectionSection: CollectionSection{ return self }
}
