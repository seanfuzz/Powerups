//
//  TableSection.swift
//  Powerups
//
//  Created by Sean Orelli on 12/6/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

protocol TableSectionProvider {
    var tableSection: TableSection { get }
}

/*_____________________________________________
 
                Table Section
 _____________________________________________*/
class TableSection: NSObject, TableSectionProvider {
    
    var rows = [TableItem]()
    var title: String?
    var open: Bool = true
    var hidden: Bool = false
    var indexName: String?
    var header: UIView?
    
    func add(item: TableItem){
        rows.append(item)
    }
    
    var tableSection: TableSection{ return self }
}
