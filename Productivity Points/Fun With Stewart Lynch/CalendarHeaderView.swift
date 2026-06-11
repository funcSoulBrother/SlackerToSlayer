//
//  CalendarHeaderView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 7/19/25.
//

import SwiftUI
import SwiftData

struct CalendarHeaderView: View {
    @Environment(\.modelContext) private var context
    @State private var monthDate = Date.now
    @State private var years: [Int] = []
    @State private var selectedMonth = Date.now.monthInt
    @State private var selectedYear = Date.now.yearInt
    let months = Date.fullMonthNames
    @Query private var missionCompletions: [MissionCompletion]
    @Query(sort: \Mission.points) private var missions: [Mission]
    @Query private var appearanceSettings: [AppearanceSettings]
    var previewAppearance: AppearanceSettings?
    var totalPointsForSelectedMonth: Int {
        missionCompletions
            .filter {
                $0.date.monthInt == selectedMonth &&
                $0.date.yearInt == selectedYear
            }
            .map { $0.mission.points }
            .reduce(0, +)
    }
    
    var body: some View {
        let colorSettings = ColorSettings.shared(in: context)
        let appearance = appearanceSettings.first ?? {
            let new = AppearanceSettings()
            context.insert(new)
            try? context.save()
            return new
        }()
        let currentStreak = StreakCalculator.currentStreak(from: missionCompletions)
        let longestStreak = StreakCalculator.longestStreak(from: missionCompletions)
        NavigationStack {
        ZStack {
            Color(appearance.mode == .arcade ? "ArcadeBG" : "EasyBG")
                .ignoresSafeArea()
                VStack {
                    HStack {
                        Picker("", selection: $selectedMonth) {
                            ForEach(months.indices, id: \.self) { index in
                                Text(months[index])
                                    .tag(index + 1)
                            }
                        }
                        .pickerStyle(.menu)
                        Picker("", selection: $selectedYear) {
                            ForEach(years, id:\.self) { year in
                                Text(String(year))
                            }
                        }
                    }
                    .tint(colorSettings.accentColor)
                    .buttonStyle(.bordered)

                    CalendarView(date: monthDate)
                        .id(monthDate)
                    if appearance.mode == .arcade {
                        Group {
                            Text("Total Monthly Points: \(totalPointsForSelectedMonth)")
                                .padding(.top, 20)
                            Text("Current Streak: \(currentStreak)")
                                .padding(.top, 30)
                            Text("Longest Streak: \(longestStreak)")
                                .padding(.top, 10)
                        }
                            .font(.custom("PressStart2P-Regular", size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(colorSettings.accentColor)
                            .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                    } else {
                        Group {
                            Text("Total Monthly Points: \(totalPointsForSelectedMonth)")
                                .padding(.top, 20)
                            Text("Current Streak: \(currentStreak)")
                                .padding(.top, 30)
                            Text("Longest Streak: \(longestStreak)")
                                .padding(.top, 10)
                        }
                            .font(.title)
                            .transition(.scale)
                            .foregroundStyle(colorSettings.accentColor)
                            .fontWeight(.semibold)
                    }
                }
            }
            .onAppear {
                years = Array(Set(missionCompletions.map {$0.date.yearInt}.sorted()))
            }
            .onChange(of: selectedYear) {
                updateDate()
            }
            
            .onChange(of: selectedMonth) {
                updateDate()
            }
        }
    }
    
    func updateDate() {
        monthDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1))!
    }
}

#Preview {
    CalendarHeaderView(previewAppearance: AppearanceSettings(mode: .arcade))
        .modelContainer(MissionCompletion.preview)
        .environment(ColorSettings())
}
