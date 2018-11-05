//
//  PinPoint.swift
//  KoalaPay
//
//  Created by Sean Orelli on 8/14/18.
//  Copyright © 2018 Fuzz Productions, LLC. All rights reserved.
//

import UIKit

protocol PinLayoutGuide {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
   	var trailingAnchor: NSLayoutXAxisAnchor { get }
   	var leftAnchor: NSLayoutXAxisAnchor { get }
   	var rightAnchor: NSLayoutXAxisAnchor { get }
   	var topAnchor: NSLayoutYAxisAnchor { get }
   	var bottomAnchor: NSLayoutYAxisAnchor { get }
   	var centerXAnchor: NSLayoutXAxisAnchor { get }
   	var centerYAnchor: NSLayoutYAxisAnchor { get }
	var widthAnchor: NSLayoutDimension { get }
   	var heightAnchor: NSLayoutDimension { get }
}

extension UILayoutGuide: PinLayoutGuide {}

private enum PinEdge {
	case top
	case bottom
	case left
	case right

	var isYaxis: Bool { return !isXaxis }
	var isXaxis: Bool {
		switch self {
			case .top, .bottom: return false
			case .left, .right: return true
		}
	}

	var opposite: PinEdge {
		switch self {
			case .top: return .bottom
			case .bottom: return .top
			case .left: return .right
			case .right: return .left
		}
	}

	var prev: PinEdge { return opposite.next }
	var next: PinEdge {
		switch self {
			case .top: return .left
			case .left: return .bottom
			case .bottom: return .right
			case .right: return .top
		}
	}
}

enum PinAnchor: String {//}, CaseIterable {
	case width = "WidthPinAnchor"
	case height = "HeightPinAnchor"
	case top = "TopPinAnchor"
	case bottom = "BottomPinAnchor"
	case left = "LeftPinAnchor"
	case right = "RightPinAnchor"
	case centerX = "CenterXPinAnchor"
	case centerY = "CenterYPinAnchor"

	static func allNames() -> [PinAnchor] {
		let names: [PinAnchor] = [.top, .bottom, .left, .right, .centerX, .centerY, .width, .height]
		return names
	}
}

struct PinOptions {

	var view: UIView
	var toView: UIView
	var center: Bool = false
	var top, bottom, left, right, x, y, width, height: CGFloat?

	private var edgeInsets: UIEdgeInsets {
		return UIEdgeInsets(top: top ?? 0, left: left ?? 0, bottom: bottom ?? 0, right: right ?? 0)
	}

	private var edges: [PinEdge] {
		let e: [(CGFloat?, PinEdge)] = [(top, .top), (bottom, .bottom), (left, .left), (right, .right)]
		return e.compactMap { (point, edge) in
			if point != nil { return edge }
			return nil
		}
	}

	private var isEuclidean: Bool {
		return center == false && x != nil && y != nil && edges.count == 0
	}

	private func pinPoint(view: UIView) -> PinPoint {
		if top != nil && left != nil && bottom == nil && right != nil { return .top(view) }
		if top != nil && left == nil && bottom == nil && right == nil { return .top(view) }
		if top != nil && left != nil && bottom == nil && right == nil { return .topLeft(view) }
		if top != nil && left == nil && bottom == nil && right != nil { return .topRight(view) }
		if top == nil && left != nil && bottom == nil && right == nil { return .left(view) }
		if top != nil && left != nil && bottom != nil && right == nil { return .left(view) }
		if top == nil && left == nil && bottom == nil && right != nil { return .right(view) }
		if top != nil && left == nil && bottom != nil && right != nil { return .right(view) }
		if top == nil && left == nil && bottom != nil && right == nil { return .bottom(view) }
		if top == nil && left != nil && bottom != nil && right != nil { return .bottom(view) }
		if top == nil && left != nil && bottom != nil && right == nil { return .bottomLeft(view) }
		if top == nil && left == nil && bottom != nil && right != nil { return .bottomRight(view) }
		return .center(view)
	}

	mutating func setPin() {
		view.removePinConstriants()

		// No Size specified
		if width == nil && height == nil {
			//set width and height to existing frame size
			if view.frame.width != 0 && view.frame.height != 0 {
				width = view.frame.width
				height = view.frame.height
			}
			//change x and y to top and left if applicable
			if x != nil { left = left ?? x }
			if y != nil { top = top ?? y }
		}

		if isEuclidean { return pinToFrame() }

		if edges.count == 0 {
			if width != nil && height != nil { return pinToSize() }
			if width != nil {return pinToWidth()}
			if height != nil {return pinToHeight()}
			return pin(insets: UIEdgeInsets())
		}

		switch edges.count {
			case 1: pinToEdge()
			case 2: pinTwoEdges()
			case 3: pinThreeEdges()
			case 4: pin(insets: edgeInsets)
			default: break
		}
	}

	/*
	func pinToSafeArea(_ view: UIView? = nil) {
		guard let view = viewOrSuperView(view) else { return }
		pinToLayout(guide: view.layoutMarginsGuide)
	}*/
	private func pin(insets: UIEdgeInsets = UIEdgeInsets()) {
		pin(top: insets.top)
		pin(bottom: insets.bottom)
		pin(left: insets.left)
		pin(right: insets.right)
	}

	private func pin(top: CGFloat) {
		pinYAnchor(anchorA: view.topAnchor, anchorB: toView.topAnchor, constant: top, pinConstraint: PinAnchor.top)
	}

	private func pin(bottom: CGFloat) {
		pinYAnchor(anchorA: view.bottomAnchor, anchorB: toView.bottomAnchor, constant: -bottom, pinConstraint: PinAnchor.bottom)
	}

	private func pin(left: CGFloat) {
		pinXAnchor(anchorA: view.leftAnchor, anchorB: toView.leftAnchor, constant: left, pinConstraint: PinAnchor.left)
	}

	private func pin(right: CGFloat) {
		pinXAnchor(anchorA: view.rightAnchor, anchorB: toView.rightAnchor, constant: -right, pinConstraint: PinAnchor.right)
	}

	//anchorA, anchorB, constant, constraint
	private func pinXAnchor(anchorA: NSLayoutXAxisAnchor, anchorB: NSLayoutXAxisAnchor, constant: CGFloat, pinConstraint: PinAnchor) {
		let constraint = anchorA.constraint(equalTo: anchorB, constant: constant)
		setPinConstraint(view: view, name: pinConstraint, constraint: constraint)
	}
	private func pinYAnchor(anchorA: NSLayoutYAxisAnchor, anchorB: NSLayoutYAxisAnchor, constant: CGFloat, pinConstraint: PinAnchor) {
		let constraint = anchorA.constraint(equalTo: anchorB, constant: constant)

		setPinConstraint(view: view, name: pinConstraint, constraint: constraint)
	}

	private func pin(width: CGFloat) {
		let widthConstraint = view.widthAnchor.constraint(equalToConstant: width)
		setPinConstraint(view: view, name: PinAnchor.width, constraint: widthConstraint)
		view.frame.size.width = width
	}

	private func pin(height: CGFloat) {
		let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
		setPinConstraint(view: view, name: PinAnchor.height, constraint: heightConstraint)
		view.frame.size.height = height
	}

	private func setPinConstraint(view: UIView, name: PinAnchor, constraint: NSLayoutConstraint) {
		view.associatedObjects[name.rawValue] = constraint
		constraint.isActive = true
	}

	private func pinCenterX() {
		let constraint = view.centerXAnchor.constraint(equalTo: toView.centerXAnchor)
		view.associatedObjects[PinAnchor.centerX.rawValue] = constraint
		constraint.isActive = true
	}

	private func pinCenterY() {
		let constraint = view.centerYAnchor.constraint(equalTo: toView.centerYAnchor)
		view.associatedObjects[PinAnchor.centerY.rawValue] = constraint
		constraint.isActive = true
	}

	private func pin(frame: CGRect) {
		//here we need to account for the relive coords
		pin(top: frame.origin.y)
		pin(left: frame.origin.x)
		pin(size: frame.size)
		view.frame = frame
	}

	private func pin(size: CGSize) {
		pin(width: size.width)
		pin(height: size.height)
		view.frame.size = size
	}

	private func pinToFrame() {
		view.frame = CGRect(x: x ?? 0, y: y ?? 0, width: width ?? 0, height: height ?? 0)
		pin(frame: view.frame)
	}

	private func pin(edge: PinEdge, constant: CGFloat = 0) {
		switch edge {
			case .top:pin(top: constant)
			case .bottom:pin(bottom: constant)
			case .left:pin(left: constant)
			case .right:pin(right: constant)
		}
	}

	private func pinToEdge() {
		guard let edge = edges.first else { return }

		if let w = width, let h = height {
			pin(size: CGSize(width: w, height: h))
		} else if let w = width {
			pin(width: w)
			if edge.isYaxis {
				pin(edge: edge.opposite)
			} else {
				pin(edge: edge.next)
				pin(edge: edge.prev)
			}
		} else if let h = height {
			pin(height: h)
			if edge.isXaxis {
				pin(edge: edge.opposite)
			} else {
				pin(edge: edge.next)
				pin(edge: edge.prev)
			}
		} else {
			pin(edge: edge.opposite)
			pin(edge: edge.next)
			pin(edge: edge.prev)
		}
		pinAllEdges(center: true)
	}

	private func pinOrthogonalEdges(one: PinEdge, two: PinEdge) {
		pinAllEdges()

		if let w = width, let h = height {
			pin(size: CGSize(width: w, height: h))
		} else if let w = width {
			pin(width: w)
			if one.isYaxis {
				pin(edge: one.opposite)
			} else {
				pin(edge: two.opposite)
			}
		} else if let h = height {
			pin(height: h)
			if one.isXaxis {
				pin(edge: one.opposite)
			} else {
				pin(edge: two.opposite)
			}

		} else {
			pin(edge: one.opposite)
			pin(edge: two.opposite)
		}
	}

	private func pinOppositeEdges(one: PinEdge, two: PinEdge) {
		pinAllEdges()

 		if let w = width {
 			pin(width: w)
 			pinCenterX()
		}

		if let h = height {
			pin(height: h)
			pinCenterY()
		}

		if width == nil && height == nil {
			pin(edge: one.next, constant: 0)
			pin(edge: one.prev, constant: 0)
		}
	}

	private func pinAllEdges(center: Bool = false) {
		edges.forEach { (edge) in
			switch edge {
			case .top:
				pin(top: top ?? 0)
				if center { pinCenterX() }
			case .bottom:
				pin(bottom: bottom ?? 0)
				if center { pinCenterX() }
			case .left:
				pin(left: left ?? 0)
				if center { pinCenterY() }
			case .right:
				pin(right: right ?? 0)
				if center { pinCenterY() }
			}
		}
	}

	private func pinTwoEdges() {
		let one = edges[0]
		let two = edges[1]

		if one.opposite == two {
			pinOppositeEdges(one: one, two: two)
		} else {
			pinOrthogonalEdges(one: one, two: two)
		}
	}

	private func pinThreeEdges() {
		pinAllEdges()

		if let width = width {
			pin(width: width)
		} else if let height = height {
			pin(height: height)
		} else {
			if !edges.contains(.top) { pin(top: 0) }
			if !edges.contains(.bottom) { pin(bottom: 0) }
			if !edges.contains(.left) { pin(left: 0)}
			if !edges.contains(.right) { pin(right: 0) }
		}

	}

	private func pinToHeight() {
		pin(height: height ?? 0)
		pinCenterY()
		pin(left: 0)
		pin(right: 0)
	}

	private func pinToWidth() {
		pin(width: width ?? 0)
		pinCenterX()
		pin(top: 0)
		pin(bottom: 0)
	}

	private func pinToSize() {
		pin(width: width ?? 0)
		pin(height: height ?? 0)
		pinCenterX()
		pinCenterY()
	}
}

/*___________________________

		Pin Point
___________________________*/
enum PinPoint {
	case center(UIView)
	case top(UIView)
	case bottom(UIView)
	case left(UIView)
	case right(UIView)
	case topLeft(UIView)
	case topRight(UIView)
	case bottomLeft(UIView)
	case bottomRight(UIView)

	//Special Cases
	//case topLeftRight(UIView)
	//case bottomLeftRight(UIView)

	var dX: CGFloat {
		switch self {
			case .topLeft(let view): return -view.frame.width*0.5
			case .topRight(let view): return view.frame.width*0.5
			case .bottomLeft(let view): return -view.frame.width*0.5
			case .bottomRight(let view): return view.frame.width*0.5
			case .left(let view): return -view.frame.width*0.5
			case .right(let view): return view.frame.width*0.5
			default:return 0
		}
	}

	var dY: CGFloat {
		switch self {
			case .top(let view): return -view.frame.height*0.5
			case .topLeft(let view): return -view.frame.height*0.5
			case .topRight(let view): return view.frame.height*0.5
			case .bottomLeft(let view): return -view.frame.height*0.5
			case .bottomRight(let view): return view.frame.height*0.5
			case .bottom(let view): return view.frame.height*0.5
			default:return 0
		}
	}

	func pinTo(other: PinPoint) {

		var top: CGFloat? = nil
		var bottom: CGFloat? = nil
		var left: CGFloat? = nil
		var right: CGFloat? = nil
		var toView: UIView? = nil
		var view: UIView? = nil

		switch other {
			case .top(let otherView):
			toView = otherView
			top = 0
			case .topLeft(let otherView):
			toView = otherView
			top = 0
			left = 0
			case .topRight(let otherView):
			toView = otherView
			top = 0
			right = 0
			case .bottom(let otherView):
			toView = otherView
			bottom = 0
			case .bottomLeft(let otherView):
			toView = otherView
			bottom = 0
			left = 0
			case .bottomRight(let otherView):
			toView = otherView
			bottom = 0
			right = 0
			case .left(let otherView):
			toView = otherView
			left = 0
			case .right(let otherView):
			toView = otherView
			right = 0
			case .center(let otherView):
			toView = otherView
			//default: break
		}

		switch self {
			case .top(let v): view = v
			case .topLeft(let v): view = v
			case .topRight(let v): view = v
			case .bottom(let v): view = v
			case .bottomLeft(let v): view = v
			case .bottomRight(let v): view = v
			case .left(let v): view = v
			case .right(let v): view = v
			case .center(let v): view = v
		}
		if let view = view {
			view.pin(view: toView, top: top, bottom: bottom, left: left, right: right, width: view.frame.width, height: view.frame.height)
		}

	}
}
