//
//  SettingsView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 6/10/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
//    @State var accentColor: Color = .blue
//    @EnvironmentObject var appearanceSettings: AppearanceSettings
//    @Environment(ColorSettings.self) var colorSettings
    @Environment(\.modelContext) private var context
//    @Query private var settings: [ColorSettings]
    @Query private var appearanceSettings: [AppearanceSettings]

    var body: some View {
        let colorSettings = ColorSettings.shared(in: context)
        let appearance = appearanceSettings.first ?? AppearanceSettings()
        ZStack {
            Color(appearance.arcadeAppearance ? "ArcadeBG" : "EasyBG")
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                if appearance.arcadeAppearance {
                    Text("Settings")
                        .font(.custom("PressStart2P-Regular", size: 21))
                        .foregroundStyle(colorSettings.accentColor)
                        .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                } else {
                    Text("Settings")
                        .font(.largeTitle)
                        .foregroundStyle(colorSettings.accentColor)
                }
                Text("Appearance Mode")
                    .font(.headline)
                    .foregroundStyle(appearance.arcadeAppearance ? Color("ArcadeText") : .primary)
                
                Picker("Appearance", selection: Binding(
                    get: { appearance.arcadeAppearance },
                    set: { appearance.arcadeAppearance = $0 }
                )) {
                    Text("Arcade").tag(true)
                    Text("Normal").tag(false)
                }
                .pickerStyle(.segmented)
                .tint(.blue)
                
                LabeledContent("Accent Color") {
                    ColorPicker("", selection: Binding(
                        get: { colorSettings.accentColor },
                        set: { colorSettings.accentColor = $0
                            try? context.save()
                        }
                    ), supportsOpacity: false)
                }
                
                LabeledContent("Second Accent Color") {
                    ColorPicker("", selection: Binding(
                        get: { colorSettings.secondAccentColor },
                        set: { colorSettings.secondAccentColor = $0
                            try? context.save()
                        }
                    ), supportsOpacity: false)
                }
                .foregroundStyle(appearance.arcadeAppearance ? Color("ArcadeText") : .primary)
            }
            .padding()
        }
    }
}

#Preview {
    SettingsView()
        .environment(ColorSettings())
        .environment(AppearanceSettings())
}
