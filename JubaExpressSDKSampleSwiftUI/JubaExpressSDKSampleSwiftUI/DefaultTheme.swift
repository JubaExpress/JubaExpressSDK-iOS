//
//  DefaultTheme.swift
//  Shared
//

import SwiftUI

// MARK: - SDK Theme Model

struct SDKTheme {
    var primary:                  Color = DefaultTheme.Colors.primary
    var secondary:                Color = DefaultTheme.Colors.secondory
    var tertiary:                 Color = DefaultTheme.Colors.tertiary
    var fieldBackground:          Color = DefaultTheme.Colors.filedBackgroundColor
    var topHeading:               Color = DefaultTheme.Colors.TopHeadingColor
    var buttonBackground:         Color = DefaultTheme.Colors.secondory
    var buttonText:               Color = .white
    var transferButtonBackground: Color = .black
    var transferButtonText:       Color = .white
}

public struct DefaultTheme {

    public struct Colors {
        public static let primary:              Color = Color(hex: "#4f9ddc")
        public static let secondory:            Color = Color(hex: "#4f9ddc")
        public static let tertiary:             Color = Color(hex: "#FFFFFF")
        public static let filedBackgroundColor: Color = Color(red: 0.9411764706,
                                                              green: 0.9411764706,
                                                              blue: 0.9411764706)
        public static var TopHeadingColor:      Color = Color(red: 1, green: 1, blue: 1)
    }
}

// MARK: - Color hex initialiser

public extension Color {

    init(hex: String, opacity: Double = 1.0) {
        var hexValue = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        if hexValue.hasPrefix("#") {
            hexValue.removeFirst()
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)

        let red   = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >>  8) / 255.0
        let blue  = Double( rgbValue & 0x0000FF       ) / 255.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
