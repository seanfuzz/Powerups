//
//  UISearchBar+.swift
//  Powerups
//
//  Created by Sean Orelli on 11/29/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

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
        get { return searchTextfield.textColor ??    UIColor.black }
    }
    
    override func design(){
        super.design()
        //textColor
        //searchBackgrounColor
        //searchTextField
    }
}


// Delegate Functions
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
