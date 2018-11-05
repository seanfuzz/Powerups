//
//  TableView.swift
//  Igor
//
//  Created by Sean Orelli on 8/23/18.
//  Copyright © 2018 Fuzz. All rights reserved.
//

import UIKit

class TableView: UITableView {

	var model: TableModel? {
		didSet{
			delegate = model
			dataSource = model
			if let model = model{
				register(TableCell.self, forCellReuseIdentifier: model.cellIdentifier)
			}
		}
	}

	override func design() {
		separatorStyle = .none
		backgroundColor = UIColor.backgroundColor
	}

}
