//
//  CalendarView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 6/4/25.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var color: Color = .blue
    let date: Date
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days: [Date] = []
//    let selectedActivity: Activity?
    @Query private var missionCompletions: [MissionCompletion]
    @State private var counts = [Int : Int]()
    
    init(date: Date) {
        self.date = date
//        self.selectedActivity = selectedActivity
        let endOfMonthAdjustment = Calendar.current.date(byAdding: .day, value: -1, to: date.endOfMonth)!
        let predicate = #Predicate<MissionCompletion> {$0.date >= date.startOfMonth && $0.date <= endOfMonthAdjustment}
        _missionCompletions = Query(filter: predicate, sort: \MissionCompletion.date)
    }
    
    var body: some View {
//        let color = selectedActivity == nil ? .blue : Color(hex: selectedActivity!.hexColor)
        VStack {
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .foregroundStyle(color)
                    ///replace with accent color
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
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .foregroundStyle(
                                        Date.now.startOfDay == day.startOfDay
                                        ? .red.opacity(counts[day.dayInt] != nil ? 0.8 : 0.3)
                                        : color.opacity(counts[day.dayInt] != nil ? 0.8 : 0.3))
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
                                            .fill(.pink)
                                            .frame(width: 40, height: 20)
//                                            .background(.pink)
                                        Text(count <= 999 ? "\(count)" : "999")
                                            .bold()
                                            .foregroundColor(.secondary)
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
//    , selectedActivity: nil)
        .modelContainer(Mission.preview)
        .modelContainer(MissionCompletion.preview)
}
