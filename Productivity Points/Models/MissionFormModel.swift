//
//  MissionFormModel.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 7/6/25.
//

import SwiftUI

@Observable
class MissionFormModel {
    var name = ""
    var colorHex: Color = .red
    var points: Int? = nil
    
    var mission: Mission?
    
    var updating: Bool { mission != nil }
    
    init() {}
    
    init(mission: Mission) {
        self.mission = mission
        self.name = mission.name
        self.colorHex = Color(hex: mission.colorHex)
        self.points = mission.points
    }
    
    var disabled: Bool {
        name.isEmpty || points == nil
    }
}
