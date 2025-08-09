//
//  CalendarHeaderView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 7/19/25.
//

import SwiftUI
import SwiftData

struct CalendarHeaderView: View {
    @State private var monthDate = Date.now
    @State private var years: [Int] = []
    @State private var selectedMonth = Date.now.monthInt
    @State private var selectedYear = Date.now.yearInt
    let months = Date.fullMonthNames
//    @Query private var workouts: [Workout]
    @Query private var missionCompletions: [MissionCompletion]
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
    var body: some View {
        NavigationStack {
            VStack {
//                Picker("", selection: $selectedActivity) {
//                    Text("All").tag(nil as Activity?)
//                    ForEach(activities) { activity in
//                        Text(activity.name).tag(activity as Activity?)
//                    }
//                }
//                .buttonStyle(.borderedProminent)
                HStack {
                    Picker("", selection: $selectedYear) {
                        ForEach(years, id:\.self) { year in
                           Text(String(year))
                        }
                    }
                    Picker("", selection: $selectedMonth) {
                    ForEach(months.indices, id: \.self) { index in
                        Text(months[index]).tag(index + 1)
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
            .navigationTitle("Super Gay Calendar")
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
    
    func updateDate() {
        monthDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1))!
    }
}

#Preview {
    CalendarHeaderView()
        .modelContainer(MissionCompletion.preview)
}
