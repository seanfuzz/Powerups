//
// Created by Andrew Grosner on 9/5/18.
// Copyright (c) 2018 Fuzz. All rights reserved.
//

import Foundation
import CoreLocation

extension CLProximity {

    var name: String {
        get {
            switch self {
            case .near:
                return "near"
            case .far:
                return "far"
            case .immediate:
                return "immediate"
            default:
                return "unknown"
            }
        }
    }
}