//
//  DefaultTheme.swift
//  Shared
//
//  Created by Fahad Usmani on 19/08/2023.
//

import UIKit

public struct DefaultTheme {
    
    public struct Colors{
      
        public static let primary : UIColor = UIColor.init(hex: "#4f9ddc")
        public static let secondory: UIColor = UIColor.init(hex: "#4f9ddc")
        public static let tertiary : UIColor = UIColor.init(hex: "#FFFFFF")
        public static let filedBackgroundColor  = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        public static var TopHeadingColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}

public extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
