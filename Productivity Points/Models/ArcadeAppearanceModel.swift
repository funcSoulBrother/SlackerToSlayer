//
//  ArcadeAppearanceModel.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 6/11/25.
//

import SwiftUI
import Combine

class AppearanceSettings: ObservableObject {
    @Published var arcadeAppearance: Bool {
        didSet {
            UserDefaults.standard.set(arcadeAppearance, forKey: "arcadeAppearance")
        }
    }
    
    init() {
        self.arcadeAppearance = UserDefaults.standard.bool(forKey: "arcadeAppearance")
    }
}
