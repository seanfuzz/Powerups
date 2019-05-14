//
//  TableCell.swift
//  Igor
//
//  Created by Sean Orelli on 8/10/18.
//  Copyright © 2018 Fuzz. All rights reserved.
//

import UIKit

/*_____________________________________________

				Table Cell
_____________________________________________*/
class TableCell: UITableViewCell
{
	let messageLabel = UILabel()

	weak var controller: TableController?

    func showCheckMark()
    {
        let label = UILabel()
        label.text = "✅"
        label.sizeToFit()
        accessoryView = label
    }
    
    func hideCheckMark()
    {
        accessoryView = nil
    }
    
	func setup(row: TableItem)
    {

		addMessageLabel(text: row.title)
		design()
        if row.selected
        {
            showCheckMark()
        }else{
            hideCheckMark()
        }

	}

	private func addMessageLabel(text: String? = nil)
    {
		contentView.addSubview(messageLabel)
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        //messageLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 12.0)

		if let t = text
        {
			messageLabel.text =  t
		}
		messageLabel.isUserInteractionEnabled = false
		messageLabel.pin(view: contentView, top: 10, bottom: 10, left: 64, right: 18)
		messageLabel.borderWidth = 0
		messageLabel.numberOfLines = 3
	}




	override func design()
    {
		//super.design()
//		messageLabel.backgroundColor = .clear
//        contentView.backgroundColor = .blue
	}

}
