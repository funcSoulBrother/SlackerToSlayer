//
//  MissionChecklist.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 6/14/25.
//

import SwiftUI
import SwiftData

struct MissionChecklistPractice: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appearanceSettings: AppearanceSettings
    @State private var selectedDate = Date()
    @State private var modalType: ModalType?
    @Query(sort: \Mission.points) private var missions: [Mission]
    let rumble = UIImpactFeedbackGenerator(style: .medium)
    var totalPointsForSelectedDate: Int {
        missions.reduce(0) { total, mission in
            isCompleted(mission) ? total + mission.points : total
        }
    }
    var highScore: (date: Date, totalPoints: Int)? {
        // Step 1: Create a [Date: Int] dictionary to sum points
        var scoreByDate: [Date: Int] = [:]

        for mission in missions {
            for completion in mission.completions {
                // Normalize date to day (no time)
                let day = Calendar.current.startOfDay(for: completion.date)
                scoreByDate[day, default: 0] += mission.points
            }
        }

        // Step 2: Find the highest scoring date
        return scoreByDate.max { $0.value < $1.value }
            .map { (date: $0.key, totalPoints: $0.value) }
    }
    @State private var animatedTotalPoints: Int = 0

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("Choose a date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding()
                
                List {
                    ForEach(missions) { mission in
                        HStack {
                            Button(action: {
                                toggleCompletion(for: mission)
                            }) {
                                Image(systemName: isCompleted(mission) ? "checkmark.square.fill" : "square")
                            }
                            if isCompleted(mission) {
                                Text("\(mission.name): \(mission.points) pts")
                                    .foregroundStyle(Color(hex: mission.colorHex))
                            } else {
                                Text("\(mission.name): \(mission.points) pts")
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
                //            RollingNumber(number: animatedTotalPoints)
                //                .padding(.bottom, 5)
                Text("Total Points: \(animatedTotalPoints)")
                    .font(.headline)
                    .padding(.bottom, 5)
                    .transition(.scale)
                if let highScore = highScore {
                    VStack {
                        Text("🏆 High Score")
                            .font(.headline)
                            .padding(.top)
                        
                        Text("\(formattedDate(highScore.date)) — \(highScore.totalPoints) pts")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.green)
                    }
                }
            }
            .task {
                updateAnimatedPoints()
            }
//            .onChange(of: selectedDate) { _ in
//                updateAnimatedPoints()
//            }
//            .onChange(of: missions.count) { _ in
//                updateAnimatedPoints()
//            }
            .toolbar {
                Button {
                    modalType = .newMission
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .sheet(item: $modalType) { sheet in
                    sheet
                        .presentationDetents([.height(450)])
                }
            }
        }
    }

    // Check if a completion exists for selectedDate
    func isCompleted(_ mission: Mission) -> Bool {
        mission.completions.contains { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    // Add/remove a completion
    func toggleCompletion(for mission: Mission) {
        if let existing = mission.completions.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }) {
            mission.completions.removeAll { $0.id == existing.id }
            modelContext.delete(existing)
        } else {
            let newCompletion = MissionCompletion(date: selectedDate, mission: mission)
            mission.completions.append(newCompletion)
            
            //
            SoundManager.shared.playSound(named: appearanceSettings.arcadeAppearance ? "AffirmativeArcade" : "AffirmativeNormal")
            rumble.impactOccurred()
        }

        try? modelContext.save()

        // ✅ Manually animate points change
        updateAnimatedPoints()
    }
    func updateAnimatedPoints() {
        let newTotal = missions.reduce(0) { total, mission in
            isCompleted(mission) ? total + mission.points : total
        }

        withAnimation(.easeOut(duration: 0.3)) {
            animatedTotalPoints = newTotal
        }
    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    MissionChecklistPractice()
        .modelContainer(Mission.preview)
        .environmentObject(AppearanceSettings())
}
