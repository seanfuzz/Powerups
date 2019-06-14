//
//  CollectionController.swift
//  Powerups
//
//  Created by Sean Orelli on 11/30/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

/*_______________________________________________________________

                    Collection Controller
_______________________________________________________________*/
class CollectionController: Controller
{
    
    var collectionModel = CollectionModel()
    var collectionView: CollectionView?
    let layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = CollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionModel.controller = self
        collectionView?.model = collectionModel
        if let collectionView = collectionView {
            view.addSubview(collectionView)
        }
        
        view.backgroundColor = UIColor.backgroundColor
        collectionView?.backgroundColor = .gray(0)
        
        collectionView?.pin(view: view)
        collectionView?.reloadData()
    }

    @discardableResult
    func add(collectionItem: CollectionItemProvider) -> CollectionItem {
        let item = collectionItem.collectionItem
        let section = collectionModel.sections.last ?? CollectionSection()
        section.rows.append(item)
        let _ = add(collectionSection: section)
        return item
    }
    
    func add(collectionItems: [CollectionItemProvider]) {
        collectionItems.forEach { let _ = add(collectionItem: $0) }
    }
    
    @discardableResult
    func add(collectionSection: CollectionSectionProvider) -> CollectionSection {
        let section = collectionSection.collectionSection
        if !collectionModel.sections.contains(section){
            collectionModel.sections.append(section)
        }
        return section
    }
 
}
