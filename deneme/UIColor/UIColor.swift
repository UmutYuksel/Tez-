//
//  UIColor.swift
//  deneme
//
//  Created by Umut Yüksel on 14.10.2022.
//

import Foundation
import UIKit

extension UIColor {
    
    static func anaMavi() -> UIColor {
        return UIColor.rgbDonustur(red: 20, green: 155, blue: 235)
    }
    
    static func orangeTint() -> UIColor {
        return UIColor.rgbDonustur(red: 255, green: 101, blue: 91)
    }
    
    static func messageGray() -> UIColor {
        return UIColor.rgbDonustur(red: 210, green: 212, blue: 212)
    }
    static func messageGreen() -> UIColor {
        return UIColor.rgbDonustur(red: 140, green: 220, blue: 207)
    }
    
    static func rgbDonustur(red : CGFloat, green : CGFloat, blue : CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
