//
//  ArcadeAppearanceModel.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 6/11/25.
//

//import SwiftUI
//import Combine
//
//class AppearanceSettings: ObservableObject {
//    @Published var arcadeAppearance: Bool {
//        didSet {
//            UserDefaults.standard.set(arcadeAppearance, forKey: "arcadeAppearance")
//        }
//    }
//    
//    init() {
//        self.arcadeAppearance = UserDefaults.standard.bool(forKey: "arcadeAppearance")
//    }
//}

import SwiftData

//@Model
//class AppearanceSettings {
//    var arcadeAppearance: Bool
//    
//    init(arcadeAppearance: Bool = true) {
//        self.arcadeAppearance = arcadeAppearance
//    }
//}

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
