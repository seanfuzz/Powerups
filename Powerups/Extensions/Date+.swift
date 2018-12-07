//
// Created by Andrew Grosner on 2018-10-10.
// Copyright (c) 2018 Fuzz. All rights reserved.
//

import Foundation


enum DateFormat: String {
    // January 1, 2019
    // Jan 1 2019
    // 1/1/19
    //
    case monthDayYear = "MM-DD-YYYY"
    
    
}

extension Date {

    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
}
