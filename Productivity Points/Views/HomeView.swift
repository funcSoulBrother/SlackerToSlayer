//
//  ContentView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 4/24/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(ColorSettings.self) var colorSettings
    @EnvironmentObject var appearanceSettings: AppearanceSettings
    let rumble = UIImpactFeedbackGenerator(style: .medium)
    //The following lets and vars are for the date picker
    @State var selectedDate: Date = Date()
    let startingDate: Date = Calendar.current.date(from: DateComponents(year: 2025)) ?? Date()
    let endingDate: Date = Date()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        ZStack {
            Color(appearanceSettings.arcadeAppearance ? "ArcadeBG" : "EasyBG")
                .ignoresSafeArea()
            VStack {
                if appearanceSettings.arcadeAppearance {
                    Text("How have you leveled up today?")
                        .font(.custom("PressStart2P-Regular", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(colorSettings.accentColor)
                        .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                        .padding()
                } else {
                    Text("How have you achieved your goals today?")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(colorSettings.accentColor)
                }
                if appearanceSettings.arcadeAppearance {
                        DatePicker("Select a Date:", selection: $selectedDate, in: startingDate...endingDate, displayedComponents: .date)
                            .font(.custom("PressStart2P-Regular", size: 15))
                            .foregroundStyle(colorSettings.accentColor)
                            .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 8, x: 0, y: 0)
                            .padding()
                } else {
                        DatePicker("Select a Date:", selection: $selectedDate, in: startingDate...endingDate, displayedComponents: .date)
                                .font(.title2)
                                .foregroundStyle(colorSettings.accentColor)
                                .padding()
                }
                
                Button("Accomplish Goal!") {
                    SoundManager.shared.playSound(named: appearanceSettings.arcadeAppearance ? "AffirmativeArcade" : "AffirmativeNormal")
                    rumble.impactOccurred()
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(ColorSettings())
        .environmentObject(AppearanceSettings())
}
