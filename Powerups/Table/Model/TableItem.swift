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
    public var height: CGFloat = 100
//    var emoji: String?
    var cellIdentifier: String { return "TableCell" }
    
    var autoDeselect = true
    var selectedAction: Closure<IndexPath>?
    var deselectedAction: Block?
    
    var tableItem: TableItem { return self }
    var pickerElements: [String]?
    var selected = false
    
    var selectionStyle:UITableViewCell.SelectionStyle = .default
    
    convenience init(title: String)
    {
        self.init()
        self.title = title
    }
    
    func cell(tableView: UITableView) -> TableCell
    {
        let cell = TableCell()
        cell.hideCheckMark()
        cell.accessoryView = nil
        cell.isHighlighted = true
        cell.isSelected = selected
        cell.selectionStyle = self.selectionStyle
        cell.messageLabel.font = UIFont.systemFont(ofSize: 10)
        return cell
    }
    
}


protocol TableItemProvider
{
    var tableItem: TableItem { get }
}


extension String: TableItemProvider
{
    
    var tableItem: TableItem
    {
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
