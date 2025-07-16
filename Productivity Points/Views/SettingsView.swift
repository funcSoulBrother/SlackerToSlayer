//
//  SettingsView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 6/10/25.
//

import SwiftUI

struct SettingsView: View {
//    @State var accentColor: Color = .blue
    @EnvironmentObject var appearanceSettings: AppearanceSettings
    @Environment(ColorSettings.self) var colorSettings

    var body: some View {
        ZStack {
            Color(appearanceSettings.arcadeAppearance ? "ArcadeBG" : "EasyBG")
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                if appearanceSettings.arcadeAppearance {
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
                    .foregroundStyle(appearanceSettings.arcadeAppearance ? Color("ArcadeText") : .primary)
                
                Picker("Appearance", selection: Binding(
                    get: { appearanceSettings.arcadeAppearance },
                    set: { appearanceSettings.arcadeAppearance = $0 }
                )) {
                    Text("Arcade").tag(true)
                    Text("Normal").tag(false)
                }
                .pickerStyle(.segmented)
                .tint(.blue)
                
                LabeledContent("Accent Color") {
                    ColorPicker("", selection: Binding(
                        get: { colorSettings.accentColor },
                        set: { colorSettings.accentColor = $0 }
                    ), supportsOpacity: false)
                }
                .foregroundStyle(appearanceSettings.arcadeAppearance ? Color("ArcadeText") : .primary)
            }
            .padding()
        }
    }
}

#Preview {
    SettingsView()
        .environment(ColorSettings())
        .environmentObject(AppearanceSettings())
}
