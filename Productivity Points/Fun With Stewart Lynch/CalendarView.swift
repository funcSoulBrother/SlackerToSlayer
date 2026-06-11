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
    @State private var color: Color = .blue
    let date: Date
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days: [Date] = []
    @Query private var missionCompletions: [MissionCompletion]
    @Query private var appearanceSettings: [AppearanceSettings]
    @State private var counts = [Int : Int]()
    
    init(date: Date) {
        self.date = date
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
                            .overlay(alignment: .bottomTrailing) {
                                if let count = counts[day.dayInt] {
                                    ZStack {
                                        Capsule()
                                            .fill(colorSettings.secondAccentColor)
                                            .frame(width: 40, height: 20)
                                        Text(count <= 999 ? "\(count)" : "999")
                                            .bold()
                                            .foregroundStyle(Color(appearance.mode == .arcade ? "ArcadeBG" : "EasyBG"))
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
    }

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
