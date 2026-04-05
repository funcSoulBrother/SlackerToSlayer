//
//  AccentColorModel.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 6/10/25.
//

import SwiftData
import SwiftUI

@Model
class ColorSettings {
    var accentColorHex: String
    var secondAccentColorHex: String
    
    init(accentColor: Color = .blue, secondAccentColor: Color = .mint) {
        self.accentColorHex = accentColor.toHex() ?? "0000FF" // blue default
        self.secondAccentColorHex = secondAccentColor.toHex() ?? "FF0000" // red default
    }
    
    var accentColor: Color {
        get { Color(hex: accentColorHex, defaultColor: .blue) }
        set { accentColorHex = newValue.toHex() ?? "0000FF" }
    }
    
    var secondAccentColor: Color {
        get { Color(hex: secondAccentColorHex, defaultColor: .red) }
        set { secondAccentColorHex = newValue.toHex() ?? "FF0000" }
    }
}

extension ColorSettings {
    @MainActor
    static func shared(in context: ModelContext) -> ColorSettings {
        let descriptor = FetchDescriptor<ColorSettings>()
        if let existing = try? context.fetch(descriptor).first {
            return existing
        } else {
            let defaults = ColorSettings() // blue + red
            context.insert(defaults)
            try? context.save()
            return defaults
        }
    }
}
