//
//  TableModel.swift
//  Igor
//
//  Created by Sean Orelli on 8/10/18.
//  Copyright © 2018 Fuzz. All rights reserved.
//

import UIKit
class EditTableModel: TableModel
{
    var willDeleteAction: Closure<IndexPath>?
    var wasDeletedAction: Closure<IndexPath>?
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
         if editingStyle == .delete
         {
            
            willDeleteAction?(indexPath)
            sections[indexPath.section].rows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            wasDeletedAction?(indexPath)
         }
    }
}
/*_____________________________________________

				Table Model
_____________________________________________*/
class TableModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    
	var sections = [TableSection]()
	let defaultRowHeight = CGFloat(100)
	let cellIdentifier = "TableCell"
    var autoDeselect = true
	weak var controller: TableController?

    
	func itemAt(indexPath: IndexPath) -> TableItem?
    {
		guard sections.count > indexPath.section else { return nil }
		guard sections[indexPath.section].rows.count > indexPath.row  else { return nil }
		return sections[indexPath.section].rows[indexPath.row]
	}

	func numberOfSections(in tableView: UITableView) -> Int
    {
		return sections.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
		guard sections.count > section else { return 0 }
		return sections[section].rows.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
 		guard let row = itemAt(indexPath: indexPath) else {
            print("defafult cell")
            return TableCell()
        }

		let cell = row.cell(tableView: tableView)
		cell.controller = self.controller

		cell.setup(row: row)
		return cell
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
		guard sections.count > section else { return nil }
		return sections[section].title
	}
    
	func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int)
    {
    	if let tableViewHeaderFooterView = view as? UITableViewHeaderFooterView
        {
			tableViewHeaderFooterView.design()
    	}
	}

//	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
//
//	}

	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
		if let row = itemAt(indexPath: indexPath)
        {
			return row.height
		}

		return defaultRowHeight
	}

	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let row = itemAt(indexPath: indexPath)
        {
            if row.autoDeselect
            {
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
            row.selected = !row.selected
            row.selectedAction?(indexPath)
        }

	}


}
