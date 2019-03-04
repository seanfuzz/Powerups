//
//  CGFloat.swift
//  Powerups
//
//  Created by Sean Orelli on 3/1/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import UIKit

extension CGFloat
{
    func convertedToRadians() -> CGFloat
    {
        return CGFloat(Double(self) * Double.pi / 180.0)
    }
}


