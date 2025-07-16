//
//  MissionModel.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 6/12/25.
//

//import Foundation
import SwiftUI
import SwiftData

@Model
class Mission {
    var id: UUID
    var name: String
    var points: Int
    var colorHex: String
    var completions: [MissionCompletion] = []
    
    init(id: UUID, name: String, points: Int, colorHex: String) {
        self.id = id
        self.name = name
        self.points = points
        self.colorHex = colorHex
    }
}

extension Mission {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: Mission.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        var sampleMissions: [Mission] {
            [
                Mission(id: UUID(), name: "Masturbate", points: 1, colorHex: "6F223D"),
                Mission(id: UUID(), name: "Kill a man", points: 15, colorHex: "000000"),
                Mission(id: UUID(), name: "Eat a whole cake", points: 4, colorHex: "BBFE41"),
                Mission(id: UUID(), name: "Drink a whole gallon of milk", points: 4, colorHex: "019956"),
                Mission(id: UUID(), name: "EGOT", points: 100, colorHex: "FFD700")
            ]
        }
        for mission in sampleMissions {
            container.mainContext.insert(mission)
        }
        
        return container
    }
}
