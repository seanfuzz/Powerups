//
//  TableModel.swift
//  Igor
//
//  Created by Sean Orelli on 8/10/18.
//  Copyright © 2018 Fuzz. All rights reserved.
//

import UIKit

/*_____________________________________________

				Table Model
_____________________________________________*/
class TableModel: NSObject, UITableViewDataSource, 	UITableViewDelegate {
	var sections = [TableSection]()
	let defaultRowHeight = CGFloat(100)
	let cellIdentifier = "TableCell"

	weak var controller: TableController?

	func rowFor(indexPath: IndexPath) -> TableItem? {
		guard sections.count > indexPath.section else { return nil }
		guard sections[indexPath.section].rows.count > indexPath.row  else { return nil }
		return sections[indexPath.section].rows[indexPath.row]
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard sections.count > section else { return 0 }
		return sections[section].rows.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 		guard let row = rowFor(indexPath: indexPath) else { return TableCell() }

		let cell = row.cell(tableView: tableView)
		cell.controller = self.controller
 		// tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier) as? TableCell else { return TableCell() }
 		//let newCell:BeaconTableCell = tableView.dequeCell()
		cell.setup(row: row)

		return cell
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard sections.count > section else { return nil }
		return sections[section].title
	}
	func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
    	if let tableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
			tableViewHeaderFooterView.design()
    	}
	}

//	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
//
//	}


	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if let row = rowFor(indexPath: indexPath) {
			return row.height
		}

		return defaultRowHeight
	}

	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
		if let row = rowFor(indexPath: indexPath) {
			row.isSelected = !row.isSelected
		}
	}

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
	var selectedAction: Closure?
	var deselectedAction: Closure?

	var tableItem: TableItem { return self }
	var pickerElements: [String]?
	
	convenience init(title: String) {
		self.init()
		self.title = title
	}
	
	@objc dynamic var isSelected = false {
		didSet{
			isSelected ? selectedAction?() : deselectedAction?()
			if isSelected && autoDeselct {
				delay(0.1) { [unowned self] in
					self.isSelected = false
				}
			}
		}
	}

	func cell(tableView: UITableView) -> TableCell {
		return TableCell()
	}

}


protocol TableItemProvider {
	var tableItem: TableItem { get }
}

protocol TableSectionProvider {
	var tableSection: TableSection { get }
}

extension String: TableItemProvider {

	var tableItem: TableItem {
		let item = TableItem()
		item.title = self
		return item
	}

}


