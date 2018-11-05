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
class TableCell: UITableViewCell {

	let messageView = UITextView()
	let messageLabel = UILabel()
	let bgView = UIView()


	//Emoji View
	let circle = UIView()
	public let emojiView = UILabel()
	var observer: NSKeyValueObservation?

	weak var controller: TableController?

	func setup(row: TableItem) {

		observer = row.observe(\.isSelected) { (row, change) in
			mainQueue(){ [unowned self] in
				if row.isSelected { self.selected() } else { self.deselected() }
			}
		}

		contentView.addSubview(bgView)
		bgView.pin(view: contentView, top: 10, bottom: 10, left: 0, right: 0)

		addMessageLabel(text: row.title)
		contentView.addSubview(circle)
		circle.frame = CGRect(x: 10, y: 24, width: 48, height: 48)
		circle.addSubview(emojiView)
		emojiView.align(width:1.2, height:1.2)
		emojiView.isHidden = true
		if let emoji = row.emoji {
			emojiView.isHidden = false
			emojiView.text = emoji
		}


		design()

	}

	private func addMessageLabel(text: String? = nil) {
		contentView.addSubview(messageLabel)
		if let t = text {
			messageLabel.text = t
		}
		messageLabel.isUserInteractionEnabled = false
		messageLabel.pin(view: contentView, top: 10, bottom: 10, left: 64, right: 18)
		messageLabel.backgroundColor = .red
		messageLabel.borderWidth = 0
		messageLabel.borderColor = .white
		messageLabel.numberOfLines = 3
	}

	private func addMessageView(text: String) {
		contentView.addSubview(messageView)
		messageView.text = text
		messageView.isEditable = false
		messageView.isUserInteractionEnabled = false
		messageView.frame = contentView.bounds
		messageView.pin(view: contentView, top: 10, bottom: 10, left: 64, right: 18)
		messageView.backgroundColor = .red
		messageView.borderWidth = 1
		messageView.borderColor = .white
	}

	func selected() {
		UIView.animate(withDuration: 0.1) { [unowned self] in
			self.bgView.backgroundColor = .cellSelectedColor
			self.messageView.backgroundColor = .cellSelectedColor
		}
	}

	func deselected() {
		UIView.animate(withDuration: 0.2) { [unowned self] in
			self.bgView.backgroundColor = .cellColor
			self.messageView.backgroundColor = .cellColor
		}
	}

	override func design() {
		super.design()
		selectionStyle = .none
		bgView.backgroundColor = .cellColor
		bgView.layer.cornerRadius = 16


		circle.backgroundColor = .gray(6)
		circle.cornerRadius = 24
		emojiView.textAlignment = .center
		emojiView.backgroundColor = .clear
		emojiView.cornerRadius = circle.cornerRadius
		emojiView.font = UIFont.systemFont(ofSize: 16)
		emojiView.textColor = .white

		//messageView.backgroundColor = .cellColor
		//messageView.textColor = UIColor.cellTextColor
		//messageView.centerVertically()
		messageLabel.backgroundColor = .clear
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		//messageView.centerVertically()
	}
}
