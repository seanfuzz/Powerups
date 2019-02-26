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
@objc class TableItem: NSObject, TableItemProvider {
    
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var height: CGFloat = 100
    var emoji: String?
    var cellIdentifier: String { return "TableCell" }
    
    var autoDeselct = true
    var selectedAction: Block?
    var deselectedAction: Block?
    
    var tableItem: TableItem { return self }
    var pickerElements: [String]?
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    //    @objc dynamic var isSelected = false {
    //        didSet{
    //            isSelected ? selectedAction?() : deselectedAction?()
    //            if isSelected && autoDeselct {
    //                delay(0.1) { [unowned self] in
    //                    self.isSelected = false
    //                }
    //            }
    //        }
    //    }
    
    func cell(tableView: UITableView) -> TableCell {
        return TableCell()
    }
    
}


protocol TableItemProvider {
    var tableItem: TableItem { get }
}


extension String: TableItemProvider {
    
    var tableItem: TableItem {
        let item = TableItem()
        item.title = self
        return item
    }
}

/*
extension UIImage: TableItemProvider {
    
    var tableItem: TableItem {
        let item = TableItem()
        item.title = ""
        
        return item
    }
}
*/
