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
