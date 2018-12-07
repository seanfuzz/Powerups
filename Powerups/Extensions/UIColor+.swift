//
//  UIColor+Blink.swift
//  Blink
//
//  Created by Sean Orelli on 8/7/18.
//  Copyright © 2018 Fuzz. All rights reserved.
//

import UIKit

/*
background
border
title
subtitle

*/
extension UIColor {

    static var darkTheme = false

    static func gray(_ n: Int) -> UIColor {
        var num = n
        if n > 10 { num = 10 }
        if n < 0 { num = 0 }
        return UIColor(white: CGFloat(1.0 - Double(num) / 10.0), alpha: 1.0)
    }

    static func text(_ n: Int) -> UIColor {
        return gray(11 - n)
    }


    static var borderColor: UIColor? {
        if darkTheme { return nil }
        return .blue
    }

    static var backgroundColor: UIColor {
        if darkTheme { return gray(8) }
        return .white
    }

    static var cellColor: UIColor {
        if darkTheme { return gray(5) }
        return .white
    }

    static var cellSelectedColor: UIColor {
        if darkTheme { return gray(2) }
        return gray(8)
    }

    static var cellTextColor: UIColor {
        if darkTheme { return gray(1) }
        return gray(9)
    }

    static var searchColor: UIColor {
        if darkTheme { return gray(2) }
        return gray(9)
    }

    static var searchTextColor: UIColor {
        if darkTheme { return gray(2) }
        return gray(9)
    }

    class var slate: UIColor {
        return UIColor(red: 67.0 / 255.0, green: 83.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
    }

    class var lightGrey: UIColor {
        return UIColor(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }

    class var rustyRed: UIColor {
        return UIColor(red: 193.0 / 255.0, green: 33.0 / 255.0, blue: 15.0 / 255.0, alpha: 1.0)
    }

    class var blinkLime: UIColor {
        return UIColor(red: 161.0 / 255.0, green: 204.0 / 255.0, blue: 58.0 / 255.0, alpha: 1.0)
    }

    class var blinkWave: UIColor {
        return UIColor(red: 0.0, green: 150.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
    }

    class var blueyGrey: UIColor {
        return UIColor(red: 169.0 / 255.0, green: 183.0 / 255.0, blue: 198.0 / 255.0, alpha: 1.0)
    }

    class var blueyGrey10: UIColor {
        return UIColor(red: 169.0 / 255.0, green: 183.0 / 255.0, blue: 198.0 / 255.0, alpha: 0.1)
    }

    class var battleshipGrey: UIColor {
        return UIColor(red: 120.0 / 255.0, green: 124.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
    }

    class var blackHaze: UIColor {
        return UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1)
    }

    class var shadowColor: UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    }

    class var blinkLightSlate40: UIColor {
        return UIColor(red: 169.0 / 255.0, green: 183 / 255.0, blue: 198 / 255.0, alpha: 0.4)
    }

    class var inputGray: UIColor {
        return UIColor(red: 227.0 / 255.0, green: 230.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0)
    }

    // New Colors

    class var wave: UIColor {
        return UIColor(red: 30.0 / 255.0, green: 110.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
    }

    class var papaya: UIColor {
        return UIColor(red: 250.0 / 255.0, green: 76.0 / 255.0, blue: 4.0 / 255.0, alpha: 1.0)
    }

    class var lime: UIColor {
        return UIColor(red: 50.0 / 255.0, green: 195.0 / 255.0, blue: 5.0 / 255.0, alpha: 1.0)
    }

    class var textDarkGray: UIColor {
        return UIColor(red: 68.0 / 255.0, green: 75.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    }

    class var modalBG: UIColor {
        return UIColor(red: 68.0 / 255.0, green: 75.0 / 255.0, blue: 85.0 / 255.0, alpha: 0.2)
    }

    class var textLightGray: UIColor {
        return UIColor(red: 106.0 / 255.0, green: 117.0 / 255.0, blue: 132.0 / 255.0, alpha: 1.0)
    }

    class var textHelperGray: UIColor {
        return UIColor(red: 151.0 / 255.0, green: 160.0 / 255.0, blue: 172.0 / 255.0, alpha: 1.0)
    }

    class var backgroundGray: UIColor {
        return UIColor(red: 198.0 / 255.0, green: 203.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0)
    }

    class var backgroundGray50: UIColor {
        return UIColor(red: 198.0 / 255.0, green: 203.0 / 255.0, blue: 210.0 / 255.0, alpha: 0.5)
    }

    class var backgrounLightGray: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 246.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    }

    class var intermediateColor: UIColor {
        return UIColor(red: 246.0, green: 194.0, blue: 102.0, alpha: 1.0)
    }

    class var papayaLight: UIColor {
        return UIColor(red: 246.0 / 255.0, green: 194.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    }

    class var aqua: UIColor {
        return UIColor(red: 154.0 / 255.0, green: 218.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }

    class var separatorGray: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
    }

    class var qrShadowColor: UIColor {
        return UIColor(red: 13.0 / 255.0, green: 53.0 / 255.0, blue: 108.0 / 255.0, alpha: 0.5)
    }
}


