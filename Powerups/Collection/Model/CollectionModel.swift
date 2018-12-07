//
//  CollectionModel.swift
//  Powerups
//
//  Created by Sean Orelli on 11/30/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit
import UIKit

/*_____________________________________________
 
                Collection Model
 _____________________________________________*/
class CollectionModel: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

    var sections = [CollectionSection]()
    let defaultRowHeight = CGFloat(100)
   
    public let cellIdentifier = "CollectionCell"
    
    var autoDeselect = true
    weak var controller: CollectionController?
    
    func itemAt(indexPath:IndexPath) -> CollectionItem? {
        if indexPath.section < sections.count {
            if indexPath.row < sections[indexPath.section].rows.count{
                return sections[indexPath.section].rows[indexPath.row]
            }
        }
        return nil
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sections.count > section {
            return sections[section].rows.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CollectionCell {
            cell.contentView.borderColor = UIColor.gray
            cell.contentView.borderWidth = 1
            cell.setup(row:sections[indexPath.section].rows[indexPath.row])
            return cell
        }
        return sections[indexPath.section].rows[indexPath.row].cell(collectionView: collectionView)
    }
    

}

extension CollectionModel : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let item = itemAt(indexPath: indexPath){
            return CGSize(width: item.height, height: item.height)
        }
        return CGSize(width: 64, height: 64)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}
