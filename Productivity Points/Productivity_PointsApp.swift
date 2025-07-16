//
//  Productivity_PointsApp.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 4/24/25.
//

import SwiftUI
import SwiftData

@main
struct Productivity_PointsApp: App {
    @State private var colorSettings = ColorSettings()
    @StateObject private var appearanceSettings = AppearanceSettings()
    
    var body: some Scene {
        WindowGroup {
            MissionChecklistPractice()
                .modelContainer(for: [Mission.self, MissionCompletion.self])
                .environment(colorSettings)
                .environmentObject(appearanceSettings)
            
        }
    }
}
