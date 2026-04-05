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
    @State var showResetToDefaultsAlert = false
    var previewAppearance: AppearanceSettings?

    var body: some View {
        let colorSettings = ColorSettings.shared(in: context)
        let appearance = previewAppearance ?? appearanceSettings.first ?? AppearanceSettings()
        ZStack {
            Color(appearance.mode == .arcade ? "ArcadeBG" : "EasyBG")
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                if appearance.mode == .arcade {
                    Text("Settings")
                        .font(.custom("PressStart2P-Regular", size: 21))
                        .foregroundStyle(.blue)
                        .shadow(color: .blue.opacity(0.8), radius: 10, x: 0, y: 0)
                } else {
                    Text("Settings")
                        .font(.largeTitle)
                        .foregroundStyle(.blue)
                }
//                Text("Appearance Mode")
//                    .font(.headline)
//                    .foregroundStyle(appearance.arcadeAppearance ? Color("ArcadeText") : .primary)
//                
//                Picker("Appearance", selection: Binding(
//                    get: { appearance.arcadeAppearance },
//                    set: { appearance.arcadeAppearance = $0 }
//                )) {
//                    Text("Arcade").tag(true)
//                    Text("Normal").tag(false)
//                }
//                .pickerStyle(.segmented)
//                .tint(.blue)
                
                Text("Appearance Mode")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.blue)

                                // Custom arcade-style toggle
                                HStack(spacing: 0) {
                                    ForEach(AppearanceMode.allCases, id: \.self) { mode in
                                        Button {
                                            appearance.mode = mode
                                            try? context.save()
                                        } label: {
                                            Text(mode.rawValue.capitalized)
                                                .frame(maxWidth: .infinity, minHeight: 40)
                                                .background(appearance.mode == mode ? Color.blue : Color.gray.opacity(0.2))
                                                .foregroundColor(.white)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                Text("(Normal mode supports your phone's current Light/Dark mode setting)")
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundStyle(.blue)
                
                LabeledContent("Accent Color") {
                    ColorPicker("", selection: Binding(
                        get: { colorSettings.accentColor },
                        set: { colorSettings.accentColor = $0
                            try? context.save()
                        }
                    ), supportsOpacity: false)
                }
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(colorSettings.accentColor)
                
                LabeledContent("Second Accent Color") {
                    ColorPicker("", selection: Binding(
                        get: { colorSettings.secondAccentColor },
                        set: { colorSettings.secondAccentColor = $0
                            try? context.save()
                        }
                    ), supportsOpacity: false)
                }
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(colorSettings.secondAccentColor)
                
                Button {
                    showResetToDefaultsAlert = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                        Text("Reset to Defaults")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .foregroundStyle(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .alert("Reset to Defaults?", isPresented: $showResetToDefaultsAlert) {
                        Button("No", role: .cancel) {}
                        Button("Yes I'm sure") {
                            appearance.mode = .arcade
                            colorSettings.accentColor = .blue
                            colorSettings.secondAccentColor = .mint
                            try? context.save()
                        }
                    } message: {
                        Text("Are you sure you want Appearance Mode, Accent Color, and Second Accent Color to revert back to their default values?")
                    }
                }
                .buttonStyle(.plain)
            }
            .padding()
        }
    }
}

//#Preview {
//    SettingsView()
//        .environment(ColorSettings())
//        .environment(AppearanceSettings())
//}

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: AppearanceSettings.self, configurations: config)
//    let context = container.mainContext
//
//    let mock = AppearanceSettings(mode: .arcade)
//    context.insert(mock)
//
//    return SettingsView()
//        .modelContainer(container)
//}

#Preview("Arcade Mode") {
    SettingsView(previewAppearance: AppearanceSettings(mode: .arcade))
        .environment(ColorSettings())
}

//#Preview("Normal Mode") {
//    SettingsView(previewAppearance: AppearanceSettings(mode: .normal))
//}
