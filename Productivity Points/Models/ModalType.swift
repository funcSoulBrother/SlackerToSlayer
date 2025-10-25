//
//  ModalType.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 7/3/25.
//

import SwiftUI
enum ModalType: View, Identifiable, Equatable {
    case newMission
    case updateMission(Mission)
    case help

    
    var id: String {
        switch self {
        case .newMission:
            "newMission"
        case .updateMission:
            "updateMission"
        case .help:
            "help"
        }
    }
    
    var body: some View {
        switch self {
        case .newMission:
            MissionFormView(model: MissionFormModel())
        case .updateMission(let mission):
            MissionFormView(model: MissionFormModel(mission: mission))
        case .help:
            HelpView()
        }
    }
}
