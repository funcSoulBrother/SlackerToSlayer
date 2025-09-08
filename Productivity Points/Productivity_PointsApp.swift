//
//  Productivity_PointsApp.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 4/24/25.
//

import SwiftUI
import SwiftData

//@main
//struct Productivity_PointsApp: App {
////    @State private var colorSettings = ColorSettings()
////    @StateObject private var appearanceSettings = AppearanceSettings()
//    
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .modelContainer(for: [Mission.self, MissionCompletion.self, ColorSettings.self, AppearanceSettings.self])
////                .environment(colorSettings)
////                .environmentObject(appearanceSettings)
//            
//        }
//    }
//}

import SwiftUI
import SwiftData

@main
struct ProductivityPoints: App {
    // Create the container for all models
    let container: ModelContainer = {
        let container = try! ModelContainer(
            for: Mission.self,
            MissionCompletion.self,
            ColorSettings.self,
            AppearanceSettings.self
        )
        
        // Ensure AppearanceSettings exists
        let context = ModelContext(container)
        let fetch = FetchDescriptor<AppearanceSettings>()
        if (try? context.fetch(fetch))?.isEmpty ?? true {
            context.insert(AppearanceSettings())
            try? context.save()
        }
        
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
