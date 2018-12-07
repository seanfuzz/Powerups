//
//  Dictionary+.swift
//  Powerups
//
//  Created by Sean Orelli on 12/6/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    
    //Should use URLComponents
    var httpParameterString: String {
        var params = ""
        var count = 0
        self.forEach { (key, value) in
            //            if let value = value.stringByAddingPercentEncodingForRFC3986() {
            params.append(key)
            params.append("=")
            params.append(value)
            //        }
            count += 1
            if count < self.count {
                params.append("&")
            }
        }
        return params
    }
}
