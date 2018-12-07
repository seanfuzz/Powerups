//
// Created by Andrew Grosner on 2018-09-24.
// Copyright (c) 2018 Fuzz. All rights reserved.
//

import Foundation

extension Encodable {
    var jsonDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
