//
//  HexColorExtension.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 6/29/25.
//

import SwiftUI
import UIKit

extension Color {
    init(hex: String, defaultColor: Color = .gray) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self = defaultColor
            return
        }
        
        let length = hexSanitized.count
        let r, g, b, a: Double
        
        switch length {
        case 6: // RGB
            r = Double((rgb & 0xFF0000) >> 16) / 255
            g = Double((rgb & 0x00FF00) >> 8) / 255
            b = Double(rgb & 0x0000FF) / 255
            a = 1.0
        case 8: // RGBA
            r = Double((rgb & 0xFF000000) >> 24) / 255
            g = Double((rgb & 0x00FF0000) >> 16) / 255
            b = Double((rgb & 0x0000FF00) >> 8) / 255
            a = Double(rgb & 0x000000FF) / 255
        default:
            self = defaultColor
            return
        }
        
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}

extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components else {
            return nil
        }

        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        let a: CGFloat

        if components.count == 2 {
            // Grayscale color (white + alpha)
            r = components[0]
            g = components[0]
            b = components[0]
            a = components[1]
        } else if components.count >= 3 {
            // RGB or RGBA
            r = components[0]
            g = components[1]
            b = components[2]
            a = components.count >= 4 ? components[3] : 1.0
        } else {
            return nil
        }

        if a < 1.0 {
            return String(format: "%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
}


