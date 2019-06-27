//
//  TableController.swift
//  Igor
//
//  Created by Sean Orelli on 8/8/18.
//  Copyright © 2018 Fuzz. All rights reserved.
//

import UIKit

/*_____________________________________________

				Table Controller
_____________________________________________*/
class TableController: UIViewController {

    var tableModel = TableModel() {
        didSet{
            tableView.dataSource = tableModel
            tableView.delegate = tableModel
        }
    }
	var tableView = TableView(frame: .zero, style: .plain)

	var footerView: UIView? {
		get { return tableView.tableFooterView }
		set(v) { tableView.tableFooterView = v }
	}

	var headerView: UIView? {
		get { return tableView.tableHeaderView }
		set(v) { tableView.tableHeaderView = v }
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		tableModel.controller = self
		tableView.model = tableModel
		view.addSubview(tableView)

		tableView.pin(view: view)
		tableView.reloadData()
	}

    @discardableResult
    func add(tableItem: TableItemProvider) -> TableItem {
		let item = tableItem.tableItem
		let section = tableModel.sections.last ?? TableSection()
		section.rows.append(item)
		let _ = add(tableSection: section)
		return item
	}

	func add(tableItems: [TableItemProvider]) {
		tableItems.forEach { let _ = add(tableItem: $0) }
	}

    @discardableResult
	func add(tableSection: TableSectionProvider) -> TableSection {
		let section = tableSection.tableSection
		if !tableModel.sections.contains(section){
			tableModel.sections.append(section)
		}
		return section
	}

    //
    
}
