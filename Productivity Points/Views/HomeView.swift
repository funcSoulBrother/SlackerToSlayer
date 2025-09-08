//
//  ContentView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 4/24/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
//    @EnvironmentObject var appearanceSettings: AppearanceSettings
//    @Environment(ColorSettings.self) var colorSettings
    @State private var selectedDate = Date()
    @State private var modalType: ModalType?
    @State private var showMissionDeleteAlert = false
    @State private var missionToDelete: Mission?
    @Query private var appearanceSettings: [AppearanceSettings]
    @Query(sort: \Mission.points) private var missions: [Mission]
//    @Query private var settings: [ColorSettings]
    let rumble = UIImpactFeedbackGenerator(style: .medium)
//    var totalPointsForSelectedDate: Int {
//        missions.reduce(0) { total, mission in
//            isCompleted(mission) ? total + mission.points : total
//        }
//    }
    ///delete this later:
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
    @State private var animatedTotalPoints: Int = 0

    var body: some View {
        let colorSettings = ColorSettings.shared(in: context)
        let appearance = appearanceSettings.first ?? AppearanceSettings()
            NavigationStack {
                ZStack {
                    Color(appearance.arcadeAppearance ? "ArcadeBG" : "EasyBG")
                        .ignoresSafeArea()
                    Group {
                        if missions.isEmpty {
                            ContentUnavailableView("Create your first Mission by tapping on the \(Image(systemName: "plus.circle.fill")) button at the top.", image: "launchScreen")
                            ///insert app icon instead of image: "launchScreen" when it exists
                        } else {
                            VStack {
                                if appearance.arcadeAppearance {
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
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                missionToDelete = mission
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                            Button {
                                                modalType = .updateMission(mission)
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            .tint(.blue)
                                        }
                                        .listRowBackground(
                                            Color(appearance.arcadeAppearance ? "ArcadeBG" : "EasyBG")
                                        )
                                    }
                                }
                                .listStyle(.plain)
                                .alert("Delete “\(missionToDelete?.name ?? "Mission")”?", isPresented: .constant(missionToDelete != nil), presenting: missionToDelete) { mission in
                                    Button("No", role: .cancel) {
                                        missionToDelete = nil
                                    }
                                    Button("Yes I'm sure", role: .destructive) {
                                        deleteMission(mission)
                                        missionToDelete = nil
                                    }
                                } message: { mission in
                                    Text("Are you sure you want to delete the mission “\(mission.name)”?\nThis action cannot be undone.")
                                }
                                //            RollingNumber(number: animatedTotalPoints)
                                //                .padding(.bottom, 5)
                                Text("Total Points: \(animatedTotalPoints)")
                                    .font(.headline)
                                    .padding(.bottom, 5)
                                    .transition(.scale)
//                                if let highScore = highScore {
//                                    VStack {
//                                        Text("🏆 High Score")
//                                            .font(.headline)
//                                            .padding(.top)
//                                        
//                                        Text("\(formattedDate(highScore.date)) — \(highScore.totalPoints) pts")
//                                            .font(.title2)
//                                            .bold()
//                                            .foregroundStyle(.green)
//                                    }
//                                }
                            }
                            .task {
                                updateAnimatedPoints()
                            }
                            .onChange(of: selectedDate) {
                                updateAnimatedPoints()
                            }
                            //            .onChange(of: selectedDate) { _ in
                            //                updateAnimatedPoints()
                            //            }
                            //            .onChange(of: missions.count) { _ in
                            //                updateAnimatedPoints()
                            //            }
                        }
                    }
                    .toolbar {
                        Button {
                            modalType = .newMission
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .sheet(item: $modalType) { sheet in
                            sheet
                                .presentationDetents([.height(550)])
                        }
                    }
                }
            }
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbarBackground(.clear, for: .navigationBar)
//            .toolbarBackground(.visible, for: .navigationBar)
    }

    // Check if a completion exists for selectedDate
    func isCompleted(_ mission: Mission) -> Bool {
        mission.completions.contains { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    // Add/remove a completion
    func toggleCompletion(for mission: Mission) {
        let appearance = appearanceSettings.first ?? AppearanceSettings()
        if let existing = mission.completions.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }) {
            mission.completions.removeAll { $0.id == existing.id }
            context.delete(existing)
        } else {
            let newCompletion = MissionCompletion(date: selectedDate, mission: mission)
            mission.completions.append(newCompletion)
            
            //
            SoundManager.shared.playSound(named: appearance.arcadeAppearance ? "AffirmativeArcade" : "AffirmativeNormal")
            rumble.impactOccurred()
        }

        try? context.save()

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
    ///delete this later?:
//    func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: date)
//    }
    func deleteMission(_ mission: Mission) {
        for completion in mission.completions {
            context.delete(completion)
        }
        context.delete(mission)
        try? context.save()
    }
}

#Preview {
    HomeView()
        .modelContainer(Mission.preview)
        .environment(AppearanceSettings())
        .environment(ColorSettings())
}

///START OLD HOMEVIEW
//struct HomeViewOld: View {
////    @Environment(ColorSettings.self) var colorSettings
//    @EnvironmentObject var appearanceSettings: AppearanceSettings
//    let rumble = UIImpactFeedbackGenerator(style: .medium)
//    //The following lets and vars are for the date picker
//    @State var selectedDate: Date = Date()
//    let startingDate: Date = Calendar.current.date(from: DateComponents(year: 2025)) ?? Date()
//    let endingDate: Date = Date()
//    var dateFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter
//    }
//    
//    var body: some View {
//        ZStack {
//            Color(appearanceSettings.arcadeAppearance ? "ArcadeBG" : "EasyBG")
//                .ignoresSafeArea()
//            VStack {
//                if appearanceSettings.arcadeAppearance {
//                    Text("How have you leveled up today?")
//                        .font(.custom("PressStart2P-Regular", size: 20))
//                        .multilineTextAlignment(.center)
//                        .foregroundStyle(colorSettings.accentColor)
//                        .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
//                        .padding()
//                } else {
//                    Text("How have you achieved your goals today?")
//                        .font(.largeTitle)
//                        .fontWeight(.semibold)
//                        .multilineTextAlignment(.center)
//                        .foregroundStyle(colorSettings.accentColor)
//                }
//                if appearanceSettings.arcadeAppearance {
//                        DatePicker("Select a Date:", selection: $selectedDate, in: startingDate...endingDate, displayedComponents: .date)
//                            .font(.custom("PressStart2P-Regular", size: 15))
//                            .foregroundStyle(colorSettings.accentColor)
//                            .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 8, x: 0, y: 0)
//                            .padding()
//                } else {
//                        DatePicker("Select a Date:", selection: $selectedDate, in: startingDate...endingDate, displayedComponents: .date)
//                                .font(.title2)
//                                .foregroundStyle(colorSettings.accentColor)
//                                .padding()
//                }
//                
//                MissionChecklistPractice()
//            }
//        }
//    }
//}

//#Preview {
//    HomeView()
//        .environment(ColorSettings())
//        .environmentObject(AppearanceSettings())
//}
