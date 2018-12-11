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
    case monthDayYear = "MM-dd-yyyy"
    //"yyyy-MM-dd HH:mm:ss"
    //"MMM dd,yyyy"
    //"yyyy-MM-dd HH:mm:ss +zzzz"
    //"yyyy-MM-dd'T'HH:mm:ssZ"
    /*
     
     Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
     09/12/2018                        --> MM/dd/yyyy
     09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
     Sep 12, 2:11 PM                   --> MMM d, h:mm a
     September 2018                    --> MMMM yyyy
     Sep 12, 2018                      --> MMM d, yyyy
     Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
     2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
     12.09.18                          --> dd.MM.yy
     */
}

extension DateFormatter {
    
    static var formatterCache = [String: DateFormatter]()
    
    static func cachedFormatter(_ format: DateFormat) -> DateFormatter {
        if let formatter = formatterCache[""]{ return formatter }
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatterCache[format.rawValue] = formatter
        return formatter
    }
}

extension Date {

    var nanosecond: Int { return Calendar.current.dateComponents([.nanosecond], from: self).nanosecond ?? 0 }
    var second: Int { return Calendar.current.dateComponents([.second], from: self).second ?? 0 }
    var minute: Int { return Calendar.current.dateComponents([.minute], from: self).minute ?? 0 }
    var hour: Int { return Calendar.current.dateComponents([.hour], from: self).hour ?? 0 }
    var day: Int { return Calendar.current.dateComponents([.day], from: self).day ?? 0 }
    var weekday: Int { return Calendar.current.dateComponents([.weekday], from: self).weekday ?? 0 }
    var weekOfMonth: Int { return Calendar.current.dateComponents([.weekOfMonth], from: self).weekOfMonth ?? 0 }
    var weekOfYear: Int { return Calendar.current.dateComponents([.weekOfYear], from: self).weekOfYear ?? 0 }
    var month: Int { return Calendar.current.dateComponents([.month], from: self).month ?? 0 }
    var year: Int { return Calendar.current.dateComponents([.year], from: self).year ?? 0 }

    //isToday
    //isYesterday
    //isTomorrow
    
    func stringWith(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func stringWith(format: DateFormat) -> String {
        return DateFormatter.cachedFormatter(format).string(from: self)
    }
    
    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
}
