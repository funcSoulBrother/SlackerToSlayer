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
//    @EnvironmentObject var appearanceSettings: AppearanceSettings
//    @Environment(ColorSettings.self) var colorSettings
    @State private var monthDate = Date.now
    @State private var years: [Int] = []
    @State private var selectedMonth = Date.now.monthInt
    @State private var selectedYear = Date.now.yearInt
    let months = Date.fullMonthNames
//    @Query private var workouts: [Workout]
    @Query private var missionCompletions: [MissionCompletion]
    @Query(sort: \Mission.points) private var missions: [Mission]
    @Query private var appearanceSettings: [AppearanceSettings]
//    @Query private var settings: [ColorSettings]
//    @Query(sort: \Activity.name) private var activities: [Activity]
//    @State private var selectedActivity: Activity?
    var totalPointsForSelectedMonth: Int {
        missionCompletions
            .filter {
                $0.date.monthInt == selectedMonth &&
                $0.date.yearInt == selectedYear
            }
            .map { $0.mission.points }
            .reduce(0, +)
    }
    ///delete this later!
//    var highScore: (date: Date, totalPoints: Int)? {
//        // Step 1: Create a [Date: Int] dictionary to sum points
//        var scoreByDate: [Date: Int] = [:]
//
//        for mission in missions {
//            for completion in mission.completions {
//                // Normalize date to day (no time)
//                let day = Calendar.current.startOfDay(for: completion.date)
//                scoreByDate[day, default: 0] += mission.points
//            }
//        }
//
//        // Step 2: Find the highest scoring date
//        return scoreByDate.max { $0.value < $1.value }
//            .map { (date: $0.key, totalPoints: $0.value) }
//    }
    
    var body: some View {
        let colorSettings = ColorSettings.shared(in: context)
        let appearance = appearanceSettings.first ?? AppearanceSettings()
        NavigationStack {
        ZStack {
            Color(appearance.arcadeAppearance ? "ArcadeBG" : "EasyBG")
                .ignoresSafeArea()
                VStack {
                    if appearance.arcadeAppearance {
                        Text("Monthly Scores")
                            .font(.custom("PressStart2P-Regular", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(colorSettings.accentColor)
                            .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                            .padding(.top, 40)
                            .padding(.bottom, 30)
                    } else {
                        Text("Monthly Scores")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(colorSettings.accentColor)
                            .padding(.top, 40)
                            .padding(.bottom, 30)
                    }
                    HStack {
                        Picker("", selection: $selectedMonth) {
                            ForEach(months.indices, id: \.self) { index in
                                Text(months[index]).tag(index + 1)
                            }
                        }
                        Picker("", selection: $selectedYear) {
                            ForEach(years, id:\.self) { year in
                                Text(String(year))
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                    CalendarView(date: monthDate)
                        .id(monthDate)
                    //                , selectedActivity: selectedActivity)
                    Spacer()
                    Text("Total Monthly Points: \(totalPointsForSelectedMonth)")
                        .font(.headline)
                        .padding(.top, 8)
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
//    func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: date)
//    }
}

#Preview {
    CalendarHeaderView()
        .modelContainer(MissionCompletion.preview)
        .environment(AppearanceSettings())
        .environment(ColorSettings())
}
