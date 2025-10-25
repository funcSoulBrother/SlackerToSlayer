//
//  CalendarView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 6/4/25.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var context
//    @EnvironmentObject var appearanceSettings: AppearanceSettings
//    @Environment(ColorSettings.self) var colorSettings
    @State private var color: Color = .blue
    let date: Date
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days: [Date] = []
//    let selectedActivity: Activity?
    @Query private var missionCompletions: [MissionCompletion]
    @Query private var appearanceSettings: [AppearanceSettings]
//    @Query private var settings: [ColorSettings]
    @State private var counts = [Int : Int]()
    
    init(date: Date) {
        self.date = date
//        self.selectedActivity = selectedActivity
        let endOfMonthAdjustment = Calendar.current.date(byAdding: .day, value: -1, to: date.endOfMonth)!
        let predicate = #Predicate<MissionCompletion> {
            $0.date >= date.startOfMonth &&
            $0.date <= date.endOfMonth
        }
        _missionCompletions = Query(filter: predicate, sort: \MissionCompletion.date)
    }
    
    var body: some View {
        let colorSettings = ColorSettings.shared(in: context)
        let appearance = appearanceSettings.first ?? AppearanceSettings()
        ///does this view need appearance?
//        let color = selectedActivity == nil ? .blue : Color(hex: selectedActivity!.hexColor)
        VStack {
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .foregroundStyle(colorSettings.accentColor)
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: columns) {
                ForEach(days, id: \.self) { day in
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else {
                        Text(day.formatted(.dateTime.day()))
                            .fontWeight(.bold)
                            .foregroundStyle(Color(appearance.mode == .arcade ? "ArcadeBG" : "EasyBG"))
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .foregroundStyle(
                                        Date.now.startOfDay == day.startOfDay
                                        ? colorSettings.secondAccentColor.opacity(counts[day.dayInt] != nil ? 0.8 : 0.4)
                                        : colorSettings.accentColor.opacity(counts[day.dayInt] != nil ? 0.8 : 0.4))
                            )
//                            .overlay(alignment: .bottomTrailing) {
//                                if let count = counts[day.dayInt] {
//                                    Image(systemName: count <= 50 ? "\(count).circle.fill" : "plus.circle.fill")
//                                        .foregroundColor(.secondary)
//                                        .imageScale(.medium)
//                                        .background (
//                                            Color(.systemBackground)
//                                                .clipShape(.circle)
//                                        )
//                                        .offset(x: 5, y:5)
//                                }
//                            }
                            .overlay(alignment: .bottomTrailing) {
                                if let count = counts[day.dayInt] {
                                    ZStack {
                                        Capsule()
                                            .fill(colorSettings.secondAccentColor)
                                            .frame(width: 40, height: 20)
//                                            .background(.pink)
                                        Text(count <= 999 ? "\(count)" : "999")
                                            .bold()
                                            .foregroundStyle(Color(appearance.mode == .arcade ? "ArcadeBG" : "EasyBG"))
                                        //                                        .background (
                                        //                                            Color(.pink)
                                        //                                        )
//                                            .padding(2)
//                                            .cornerRadius(25)
//                                            .offset(x: 5, y:5)
                                    }
                                    .offset(x: 10, y:5)
                                }
                            }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            days = date.calendarDisplayDays
            setupCounts()
        }
        .onChange(of: date) {
            days = date.calendarDisplayDays
        }
//        .onChange(of: selectedActivity) {
//            setupCounts()
//        }
    }
//    func setupCounts() {
//        var filteredWorkouts = workouts
//        if let selectedAcitivity {
//            filteredWorkouts = workouts.filter {$0.activity == selectedActivity}
//            let mappedItems = filteredWorkouts.map{($0.date.dayInt, 1)}
//            counts = Dictionary(mappedItems, uniquingKeysWith: +)
//        }
//    }
    func setupCounts() {
        let mappedItems = missionCompletions.map{($0.date.dayInt, $0.mission.points)}
        counts = Dictionary(mappedItems, uniquingKeysWith: +)
    }
}

#Preview {
    CalendarView(date: Date.now)
        .modelContainer(Mission.preview)
        .modelContainer(MissionCompletion.preview)
        .environment(AppearanceSettings())
        .environment(ColorSettings())
}
