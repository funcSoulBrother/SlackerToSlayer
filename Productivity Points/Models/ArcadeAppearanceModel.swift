//
//  ArcadeAppearanceModel.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 6/11/25.
//

import SwiftData

enum AppearanceMode: String, Codable, CaseIterable {
    case arcade
    case normal
}

@Model
class AppearanceSettings {
    var mode: AppearanceMode
    
    init(mode: AppearanceMode = .arcade) {
        self.mode = mode
    }
}
