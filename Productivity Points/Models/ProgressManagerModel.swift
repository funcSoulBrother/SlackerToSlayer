//
//  Untitled.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 3/21/26.
//

import SwiftUI

class ProgressManager: ObservableObject {
    @Published var missions: [Mission] = []
    @Published var lastLevel: Level = LevelSystem.level(for: 0)
    @Published var didLevelUp: Bool = false
    @Published var justLeveledTo: Level?
    @AppStorage("unlockedLevels") private var unlockedLevelsData: Data = Data()
    var unlockedLevels: Set<Int> {
        get {
            (try? JSONDecoder().decode(Set<Int>.self, from: unlockedLevelsData)) ?? []
        }
        set {
            unlockedLevelsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }
    
    var totalPointsEarned: Int {
        missions.reduce(0) { total, mission in
            total + (mission.completions.count * mission.points)
        }
    }
    
    var currentLevel: Level {
        LevelSystem.level(for: totalPointsEarned)
    }
    
    func checkForLevelUp(missions: [Mission]) -> Bool {
        let totalPoints = missions.reduce(0) { total, mission in
            total + (mission.completions.count * mission.points)
        }
        let newLevel = LevelSystem.level(for: totalPoints)
        print("----- LEVEL CHECK -----")
        print("Unlocked Levels:", unlockedLevels.sorted())
        print("Total Points:", totalPoints)
        print("New Level:", newLevel.number)
        
        if !unlockedLevels.contains(newLevel.number) {
            print("🎉 LEVEL UP TRIGGERED:", newLevel.number)
            var updated = unlockedLevels
            updated.insert(newLevel.number)
            unlockedLevels = updated
            
            objectWillChange.send() // ✅ force UI update
            
            lastLevel = newLevel
            justLeveledTo = newLevel
            didLevelUp = true
            
            return true
        }
        
        print("❌ Already unlocked:", newLevel.number)
        didLevelUp = false
        return false
    }
}
