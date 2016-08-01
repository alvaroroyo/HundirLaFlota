//
//  UIColor+HexColor.swift
//  2048_Game_Swift
//
//  Created by Alvaro Royo on 23/7/16.
//  Copyright © 2016 alvaroroyo. All rights reserved.
//

import UIKit

extension UIColor{
    class func colorWithHex(hex:String, alpha:CGFloat) -> UIColor{
        let hex_NSString: NSString = hex as NSString
        
        let red: String = hex_NSString.substringWithRange(NSRange(location: 1,length: 2))
        let green: String = hex_NSString.substringWithRange(NSRange(location: 3, length: 2))
        let blue: String = hex_NSString.substringWithRange(NSRange(location: 5, length: 2))
        
        var redInt: UInt32 = UInt32()
        var greenInt: UInt32 = UInt32()
        var blueInt: UInt32 = UInt32()
        
        let redScanner: NSScanner = NSScanner(string: red)
        let greenScanner: NSScanner = NSScanner(string: green)
        let blueScanner: NSScanner = NSScanner(string: blue)
        
        redScanner.scanHexInt(&redInt)
        greenScanner.scanHexInt(&greenInt)
        blueScanner.scanHexInt(&blueInt)
        
        return UIColor(red: CGFloat(redInt)/255.0, green: CGFloat(greenInt)/255.0, blue: CGFloat(blueInt)/255.0, alpha: alpha)
    }
}
