//
//  UIView+Pin.swift
//  KoalaPay
//
//  Created by Sean Orelli on 8/16/18.
//  Copyright © 2018 Fuzz Productions, LLC. All rights reserved.
//

import UIKit

// Set width / height equal to another view
// Place object between two other
// Stretch between two objects
// Safe Area
// Pinpoints

// autoWidth
// autoHeight

class PinConstraint: NSObject {
	var view: UIView?
	var otherView: UIView?
	var constraint: NSLayoutConstraint

	init(constraint: NSLayoutConstraint){
		self.constraint = constraint
	}
}

extension NSLayoutConstraint {
	var view: UIView? {
		return nil
	}

	var otherView: UIView? {
		return nil
	}
}

extension UIView: PinLayoutGuide {

	private func viewOrSuperView(_ view: UIView?=nil) -> UIView? { return view ?? self.superview }

	// could this be an array
	// would multiple pins help?
	// possibly allowing each edage to have a pin?
	// Max of 4?
	var pinView: UIView? { get {return associatedObjects["pinView"] as? UIView} }

	//Pinpoints
	var top: PinPoint { get { return .top(self) } set(t) { top.pinTo(other: t) }}
	var topLeft: PinPoint { get { return .topLeft(self) }set(t) {topLeft.pinTo(other: t)}}
	var topRight: PinPoint { get {return .topRight(self) }set(t) {topRight.pinTo(other: t)}}
	var bottom: PinPoint { get {return .bottom(self) }set(t) {bottom.pinTo(other: t)}}
	var bottomLeft: PinPoint { get {return .bottomLeft(self) }set(t) {bottomLeft.pinTo(other: t)}}
	var bottomRight: PinPoint { get {return .bottomRight(self) }set(t) {bottomRight.pinTo(other: t)}}
	var left: PinPoint { get {return .left(self) }set(t) {left.pinTo(other: t)}}
	var right: PinPoint { get {return .right(self) }set(t) {right.pinTo(other: t)}}
	var center: PinPoint { get {return .center(self) }set(t) {center.pinTo(other: t)}}

	var topPin: NSLayoutConstraint? { return pinConstraint(anchor: .top) }
	var bottomPin: NSLayoutConstraint? { return pinConstraint(anchor: .bottom) }
	var leftPin: NSLayoutConstraint? { return pinConstraint(anchor: .left) }
	var rightPin: NSLayoutConstraint? { return pinConstraint(anchor: .right) }
	var centerXPin: NSLayoutConstraint? { return pinConstraint(anchor: .centerX) }
	var centerYPin: NSLayoutConstraint? { return pinConstraint(anchor: .centerY) }
	var widthPin: NSLayoutConstraint? { return pinConstraint(anchor: .width) }
	var heightPin: NSLayoutConstraint? { return pinConstraint(anchor: .height) }

	private func pinConstraint(anchor: PinAnchor) -> NSLayoutConstraint? {
		if let c = associatedObjects[anchor.rawValue] as? NSLayoutConstraint { return c }
		return nil
	}

	var allPinConstraints: [NSLayoutConstraint] {
		var constraints = [NSLayoutConstraint]()

		PinAnchor.allNames().forEach { pc in
			if let c = pinConstraint(anchor: pc) {
				constraints.append(c)
			}
		}
		return constraints
	}

	func removePinConstriants() {
		translatesAutoresizingMaskIntoConstraints = false

		PinAnchor.allNames().forEach { pc in
			if let c = pinConstraint(anchor: pc) {
				c.isActive = false
				removeConstraint(c)
				associatedObjects[pc.rawValue] = nil
			}
		}
	}

	var pinX: CGFloat {
		get {
			if let left = leftPin { return left.constant }
			if let centerX = centerXPin { return centerX.constant  }
			return 0
		}
		set(x) {
			leftPin?.constant = x
			rightPin?.constant = x
			centerXPin?.constant = x
			pinView?.layoutIfNeeded()
		}
	}

	var pinY: CGFloat {
		get {
			if let top = topPin { return top.constant }
			if let centerY = centerYPin { return centerY.constant  }
			return 0
		}
		set(y) {
			topPin?.constant = y
			bottomPin?.constant = y
			centerYPin?.constant = y
			pinView?.layoutIfNeeded()
		}
	}

	func movePin(_ dx: CGFloat, _ dy: CGFloat) {
		pinX += dx
		pinY += dy
	}

	func pin(view: UIView?=nil, center: Bool = false, margin: CGFloat?=nil,
			 top: CGFloat?=nil, bottom: CGFloat?=nil, left: CGFloat?=nil, right: CGFloat?=nil,
			 x: CGFloat?=nil, y: CGFloat?=nil, width: CGFloat?=nil, height: CGFloat?=nil) {

		guard let other = viewOrSuperView(view) else { return }
		if let margin = margin {
			return pin(view: view, top: margin, bottom: margin, left: margin, right: margin)
		}

		guard width == nil || left == nil || right == nil else { print("Invalid pin on x axis"); return }
		guard height == nil || top == nil || bottom == nil else { print("Invalid pin on y axis"); return }

		var options = PinOptions(view: self, toView: other, center: center, top: top, bottom: bottom, left: left, right: right, x: x, y: y, width: width, height: height)
		options.setPin()
		associatedObjects["pinView"] = other
		other.layoutIfNeeded()
	}

	// Pin with relative values
	func align(view: UIView?=nil, center: Bool = false, margin: CGFloat?=nil,
			   top: CGFloat?=nil, bottom: CGFloat?=nil, left: CGFloat?=nil, right: CGFloat?=nil,
			   x: CGFloat?=nil, y: CGFloat?=nil, width: CGFloat?=nil, height: CGFloat?=nil) {
		guard let view = viewOrSuperView(view) else { return }
		let h  = view.frame.height
		let w  = view.frame.width

		var t: CGFloat?, b: CGFloat?, l: CGFloat?, r: CGFloat?, dx: CGFloat?, dy: CGFloat?, dw: CGFloat?, dh: CGFloat? = nil
		if let top 		= top { t = top * h }
		if let bottom 	= bottom { b = bottom * h }
		if let left 	= left { l = left * w }
		if let right 	= right { r = right * w }
		if let x 		= x { dx = x * w }
		if let y 		= y { dy = y * h }
		if let width 	= width { dw = width * w }
		if let height 	= height { dh = height * h }

		pin(view: view, center: center, margin: margin, top: t, bottom: b, left: l, right: r, x: dx, y: dy, width: dw, height: dh)
	}
}
