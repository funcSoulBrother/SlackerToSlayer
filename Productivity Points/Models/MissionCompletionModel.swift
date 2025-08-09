//
//  MissionCompletionModel.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 6/12/25.
//

import SwiftUI
import SwiftData

@Model
class MissionCompletion {
    var id: UUID
    var date: Date
    @Relationship var mission: Mission

    init(id: UUID = UUID(), date: Date, mission: Mission) {
        self.id = id
        self.date = date
        self.mission = mission
    }
}

extension MissionCompletion {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: MissionCompletion.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        
        let context = container.mainContext
        
        let drinkPoisonedWater = Mission(id: UUID(), name: "Drink Poisoned Water", points: 1, colorHex: "6F223D")
        context.insert(drinkPoisonedWater)
        
        let eatPoisonedChili = Mission(id: UUID(), name: "Eat Poisoned Chili", points: 2, colorHex: "FFFFFF")
        context.insert(eatPoisonedChili)
        
        let playWithPoisonedYoYo = Mission(id: UUID(), name: "Play with Poisoned Yo-Yo", points: 3, colorHex: "000001")
        context.insert(playWithPoisonedYoYo)
        
        let snuggleWithPoisonedTeddyBear = Mission(id: UUID(), name: "Snuggle With Poisoned Teddy Bear", points: 50, colorHex: "900101")
        
        let doPoisonedCocaine = Mission(id: UUID(), name: "Do Poisoned Cocaine", points: 200, colorHex: "000002")
        
        let batheInPoisonedSulfericAcid = Mission(id: UUID(), name: "Bathe in Poisoned Sulferic Acid", points: 985, colorHex: "000003")
        
        
        var sampleMissionCompletions: [MissionCompletion] {
            [
                MissionCompletion(id: UUID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 19))!, mission: drinkPoisonedWater),
                MissionCompletion(id: UUID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 19))!, mission: eatPoisonedChili),
                MissionCompletion(id: UUID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 19))!, mission: playWithPoisonedYoYo),
                MissionCompletion(id: UUID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 18))!, mission: drinkPoisonedWater),
                MissionCompletion(id: UUID(), date: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25))!, mission: eatPoisonedChili),
                MissionCompletion(id: UUID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 17))!, mission: playWithPoisonedYoYo),
                MissionCompletion(id: UUID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 2))!, mission: doPoisonedCocaine),
                MissionCompletion(id: UUID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 26))!, mission: batheInPoisonedSulfericAcid),
                MissionCompletion(id: UUID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 29))!, mission: batheInPoisonedSulfericAcid),
                MissionCompletion(id: UUID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 29))!, mission: doPoisonedCocaine),
                MissionCompletion(id: UUID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 5))!, mission: snuggleWithPoisonedTeddyBear)
                
            ]
        }
        for missionCompletion in sampleMissionCompletions {
            container.mainContext.insert(missionCompletion)
        }
        
        return container
    }
}
