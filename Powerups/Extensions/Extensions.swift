//
//  Extensions.swift
//  Igor
//
//  Created by Sean Orelli on 8/7/18.
//  Copyright © 2018 Fuzz. All rights reserved.
//

import UIKit

typealias Closure = ()->()
typealias NotificationClosure = (Notification)->()
typealias ClosureToBool = ()->(Bool)
typealias ClosureWithString = (String)->()
func backgroundQueue(closure:@escaping Closure) {
	DispatchQueue.global(qos: .default).async(execute: closure)
}

func mainQueue(closure:@escaping Closure) {
	DispatchQueue.main.async(execute: closure)
}

func delay(_ seconds: Double, closure:@escaping Closure) {
	DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
}


// Declare a global var to produce a unique address as the assoc object handle
private var associatedObjectKey: UInt8 = 0

extension NSObject {
    var associatedObjects: [String: Any] {
        get {
        		if let objects = objc_getAssociatedObject(self, &associatedObjectKey) as? [String: Any] {
        			return objects
        		}
        		let objects = [String: Any]()
				//assoicatedObjects = objects
				objc_setAssociatedObject(self, &associatedObjectKey, objects, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
				return objects
        }
        set {
            objc_setAssociatedObject(self, &associatedObjectKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    
	func observe(notification: String, selector:Selector){
		NotificationCenter.default.addObserver(self, selector: selector, name: Notification.Name(notification), object: nil)
	}

	func observe(notification: String, closure: @escaping NotificationClosure){
		NotificationCenter.default.addObserver(forName: Notification.Name(notification), object: self, queue: nil, using:closure)
	}

	func stopObserving(notification: String){
		NotificationCenter.default.removeObserver(self, name: Notification.Name(notification), object: nil)
	}
}

extension String {

	func notify() {
		NotificationCenter.default.post(name: Notification.Name(self), object: nil)
	}
}

extension UIView {

	var borderColor: UIColor? {
		get{ if let border = layer.borderColor { return UIColor(cgColor: border)} else { return nil } }
		set(c) { layer.borderColor = c?.cgColor }
	}

	var borderWidth: CGFloat {
		get{ return layer.borderWidth }
		set(c) { layer.borderWidth = c }
	}

	var cornerRadius: CGFloat {
		get{ return layer.cornerRadius }
		set(c) { layer.cornerRadius = c; clipsToBounds = true}
	}


	@objc func design(){
		stopObserving(notification: "Design")
		observe(notification: "Design", selector:#selector(design))
		subviews.forEach { view in view.design() }

		backgroundColor = UIColor.backgroundColor
		//borderWidth = UIView.borderWidth
		//borderColor = .blue
	}
}

extension UISearchBar {

	var searchTextfield: UITextField {
		get { return (value(forKey: "searchField") as? UITextField) ?? UITextField() }
	}

	var searchBackgroundColor: UIColor {
		get { return searchTextfield.backgroundColor ?? UIColor.white }
		set(c){ searchTextfield.backgroundColor = c }
	}

	var textColor: UIColor {
		set(c) { searchTextfield.textColor = c }
		get { return searchTextfield.textColor ??	UIColor.black }
	}

	override func design(){
		super.design()
		//textColor
		//searchBackgrounColor
		//searchTextField
	}
}

extension UITextView {

	// Does this work?
	// Maybe not in cells?
    func centerVertically() {
		var topCorrect = (bounds.size.height - contentSize.height * zoomScale) / 2.0
		topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect
		contentInset.top = topCorrect
    }

}

extension UITableView {
	//override

	override func design(){
		super.design()
		backgroundColor = UIColor.backgroundColor
	}
}

extension UITableViewHeaderFooterView {
	override func design(){
		//super.design() //This creates runtime warnings, background color is not supposed ot be changed
		textLabel?.textColor = .cellTextColor
		backgroundView?.backgroundColor = .backgroundColor
	}

}

extension UICollectionViewCell {
	override func design() {
		super.design()
		contentView.backgroundColor = .cellColor
	}
}

extension UITableViewCell {
	override func design() {
		super.design()
		contentView.backgroundColor = .backgroundColor
	}
}

extension UITextView {
	//override
	override func design() {
		//super.design()
		backgroundColor = UIColor.clear
		font = UIFont.boldSystemFont(ofSize: 24)
		textColor = UIColor.cellTextColor
	}
}

extension UILabel {
	override func design() {
		super.design()
		//backgroundColor = UIColor.clear
		font = UIFont.boldSystemFont(ofSize: 24)
		textColor = UIColor.cellTextColor
	}
}

extension UIButton {

	var title: String? {
		get { return titleLabel?.text }
		set(t) { setTitle(t, for: .normal)}
	}

	@objc private func doTouchUp() { touchUp() }
	var touchUp: Closure {
		get {
			if let a = associatedObjects["touchUp"] as? Closure { return a }
			return {}
		}
		set(a) {
			associatedObjects["touchUp"] = a
			addTarget(self, action: #selector(doTouchUp), for: .touchUpInside)
		}
	}

	@objc private func doTouchDown() { touchDown() }
	var touchDown: Closure {
		get {
			if let a = associatedObjects["touchDown"] as? Closure { return a }
			return {}
		}
		set(a) {
			associatedObjects["touchDown"] = a
			addTarget(self, action: #selector(doTouchDown), for: .touchUpInside)
		}
	}

}


extension UISearchBar: UISearchBarDelegate {

	var shouldBeginEditing: ClosureToBool? {
		get { return associatedObjects["BeginEditing"] as? ClosureToBool }
		set(c) { associatedObjects["BeginEditing"] = c; self.delegate = self }
	}

	var shouldEndEditing: ClosureToBool?  {
		get { return associatedObjects["EndEditing"] as? ClosureToBool }
		set(c) { associatedObjects["EndEditing"] = c; self.delegate = self }
	}

	var textDidChange: ClosureWithString?  {
		get { return associatedObjects["textDidChange"] as? ClosureWithString }
		set(c) { associatedObjects["textDidChange"] = c; self.delegate = self }
	}


	public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
		if let e = shouldBeginEditing { return e() }
		return true
	}

	public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
		if let e = shouldEndEditing { return e() }
		return true
	}

	public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
		textDidChange?(searchText)
	}
}

extension UITableView {

	func dequeCell<T>() -> T where T:UITableViewCell {
		let identifier = "\(T.self)"
		register(T.self, forCellReuseIdentifier: identifier)
		if let cell = dequeueReusableCell(withIdentifier: identifier) as? T {
			return cell
		}
		return T()
	}

}

extension UIViewController {
	func addChildAndView(controller: UIViewController){
        addChild(controller)
		//addChild(controller)
		view.addSubview(controller.view)
	}
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension String {
    static func todaysDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: Date())
    }
}
