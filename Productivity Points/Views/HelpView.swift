//
//  HelpView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 10/16/25.
//

import SwiftUI
import SwiftData

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    //    @EnvironmentObject var appearanceSettings: AppearanceSettings
    //    @Environment(ColorSettings.self) var colorSettings
    //    @State private var selectedDate = Date()
    ///@State private var modalType: ModalType?
    //    @State private var showMissionDeleteAlert = false
    //    @State private var missionToDelete: Mission?
    @Query private var appearanceSettings: [AppearanceSettings]
    //    @Query(sort: \Mission.points) private var missions: [Mission]
    
    var body: some View {
        let colorSettings = ColorSettings.shared(in: context)
        let appearance = appearanceSettings.first ?? {
            let new = AppearanceSettings()
            context.insert(new)
            try? context.save()
            return new
        }()
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            VStack {
                if appearance.mode == .arcade {
                    Text("Help Screen")
                        .font(.custom("PressStart2P-Regular", size: 30))
                        .multilineTextAlignment(.center)
                        .shadow(color: .primary.opacity(0.8), radius: 10, x: 0, y: 0)
                        .padding(.vertical, 20)
                } else {
                    Text("Helpful Tips")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 20)
                }
                VStack (alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                        Text("To create a new Mission, tap the \(Image(systemName: "plus.circle.fill")) button on the top right of the Home screen.")
                    }
                    HStack {
                        Image(systemName: "calendar")
                            .font(.title)
                        Text("The Home screen will default to today's date. To go to a past date (or a future date for some reason) tap on the date at the top to pick a new date.")
                    }
                    HStack {
                        Image(systemName: "checkmark.square.fill")
                            .font(.title)
                        Text("To mark a mission as complete, tap the mission text or the checkbox. To mark it as incomplete, tap it again.")
                    }
                    HStack {
                        Image(systemName: "pencil")
                            .font(.title)
                        Text("To edit a Mission, left swipe on the Mission you want to edit and tap the blue Edit button marked witht he pencil icon.")
                    }
                    HStack {
                        Image(systemName: "trash")
                            .font(.title)
                        Text("To delete a Mission, left swipe on the Mission you want to delete and tap the red Delete button marked with the trash icon.")
                    }
                    VStack (alignment: .center) {
                        if appearance.mode == .arcade {
                            Button(action: { dismiss() }) {
                                Text("Dismiss")
                                    .padding()
                                    .font(.custom("PressStart2P-Regular", size: 20))
                                    .background(colorSettings.accentColor)
                                    .foregroundStyle(.white)
                                    .cornerRadius(10)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                        } else {
                            Button(action: { dismiss() }) {
                                Text("Got it")
                                    .padding()
                                    .background(colorSettings.accentColor)
                                    .foregroundStyle(.white)
                                    .cornerRadius(10)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    HelpView()
}
