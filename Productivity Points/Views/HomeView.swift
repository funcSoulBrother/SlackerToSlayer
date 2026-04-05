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
    @EnvironmentObject var progressManager: ProgressManager
//    @EnvironmentObject var appearanceSettings: AppearanceSettings
//    @Environment(ColorSettings.self) var colorSettings
    @State private var selectedDate = Date()
    @State private var modalType: ModalType?
    @State private var showMissionDeleteAlert = false
    @State private var missionToDelete: Mission?
    @State private var flash = false
    @Query private var appearanceSettings: [AppearanceSettings]
    @Query(sort: \Mission.points) private var missions: [Mission]
//    @Query private var settings: [ColorSettings]
    let rumble = UIImpactFeedbackGenerator(style: .medium)
    var previewAppearance: AppearanceSettings?
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
        let appearance = appearanceSettings.first ?? {
            let new = AppearanceSettings()
            context.insert(new)
            try? context.save()
            return new
        }()
        NavigationStack {
            ZStack {
                Color(appearance.mode == .arcade ? "ArcadeBG" : "EasyBG")
                    .ignoresSafeArea()
                //                    if progressManager.didLevelUp {
                //                        VStack {
                //                            Text("LEVEL UP!")
                //                                .font(.custom("PressStart2P-Regular", size: 20))
                //                            Text("Level \(progressManager.currentLevel.number)")
                //                            Text(progressManager.currentLevel.title)
                //                                .font(.custom("PressStart2P-Regular", size: 16))
                //                        }
                //                        .padding()
                //                        .background(Color.black.opacity(0.8))
                //                        .cornerRadius(12)
                //                        .transition(.scale)
                //                        .onAppear {
                //                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                //                                progressManager.didLevelUp = false
                //                            }
                //                        }
                //                    }
                //                .animation(.easeInOut, value: progressManager.didLevelUp)
                Group {
                    if missions.isEmpty {
                        ContentUnavailableView("Create your first Mission by tapping on the \(Image(systemName: "plus.circle.fill")) button at the top.", image: "launchScreen")
                            .foregroundStyle(colorSettings.accentColor)
                        ///insert app icon instead of image: "launchScreen" when it exists
                    } else {
                        VStack {
                            if appearance.mode == .arcade {
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
                            HStack(spacing: 12) {
                                
                                Button {
                                    if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) {
                                        selectedDate = newDate
                                    }
                                } label: {
                                    Circle()
                                        .fill(colorSettings.secondAccentColor)
                                        .frame(width: 30, height: 30)
                                        .overlay {
                                            Image(systemName: "chevron.left")
                                                .foregroundStyle(appearance.mode == .arcade ? .black : Color("EasyBG"))
                                        }
                                }
                                
                                DatePicker(
                                    "",
                                    selection: $selectedDate,
                                    displayedComponents: .date
                                )
                                .labelsHidden()
                                .datePickerStyle(.compact)
                                .if(appearance.mode == .arcade) { view in
                                    view.environment(\.colorScheme, .dark)
                                }
                                Button {
                                    if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) {
                                        selectedDate = newDate
                                    }
                                } label: {
                                    Circle()
                                        .fill(colorSettings.secondAccentColor)
                                        .frame(width: 30, height: 30)
                                        .overlay {
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(appearance.mode == .arcade ? .black : Color("EasyBG"))
                                        }
                                }
                            }
                            if appearance.mode == .arcade {
                                Text("Total Points: \(animatedTotalPoints)")
                                    .font(.custom("PressStart2P-Regular", size: 20))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(colorSettings.accentColor)
                                    .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                                    .padding(.vertical, 20)
                            } else {
                                Text("Total Points: \(animatedTotalPoints)")
                                    .font(.largeTitle)
                                    .padding(.bottom, 5)
                                //                                        .transition(.scale)
                                    .foregroundStyle(colorSettings.accentColor)
                                    .padding(.vertical, 20)
                            }
                            List {
                                ForEach(missions) { mission in
                                    HStack {
                                        Button(action: {
                                            toggleCompletion(for: mission)
                                        }) {
                                            Image(systemName: isCompleted(mission) ? "checkmark.square.fill" : "square")
                                                .foregroundStyle(isCompleted(mission) ? Color(hex: mission.colorHex) : .gray)
                                        }
                                        if isCompleted(mission) {
                                            Text("\(mission.name): \(mission.points) pts")
                                                .foregroundStyle(Color(hex: mission.colorHex))
                                        } else {
                                            Text("\(mission.name): \(mission.points) pts")
                                                .foregroundStyle(appearance.mode == .arcade ? .white : .primary)
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
                                        Color(appearance.mode == .arcade ? "ArcadeBG" : "EasyBG")
                                    )
                                    .listRowSeparator(.hidden)
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
                            if appearance.mode == .arcade {
                                Button(action: { modalType = .newMission }) {
                                    Text("New Mission")
                                        .padding()
                                        .font(.custom("PressStart2P-Regular", size: 18))
                                        .background(colorSettings.accentColor)
                                        .foregroundStyle(Color("EasyBG"))
                                        .cornerRadius(10)
                                        .frame(maxWidth: .infinity)
                                        .padding(.bottom, 30)
                                }
                            } else {
                                Button(action: { modalType = .newMission }) {
                                    Text("New Mission")
                                        .padding()
                                        .background(colorSettings.accentColor)
                                        .foregroundStyle(Color("EasyBG"))
                                        .cornerRadius(10)
                                        .frame(maxWidth: .infinity)
                                        .padding(.bottom, 30)
                                }
                            }
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
                    ///old new mission toolbar button, get rid of this if using the button
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            modalType = .newMission
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            modalType = .help
                        } label: {
                            Image(systemName: "questionmark.circle.fill")
                        }
                    }
                }
                .sheet(item: $modalType) { sheet in
                    sheet
                        .presentationDetents(sheet == .help ? [.large] : [.height(550)])
                }
                
                if progressManager.didLevelUp {
                    ConfettiView()
                }
                
                if progressManager.didLevelUp,
                   let level = progressManager.justLeveledTo {
                    if appearance.mode == .arcade {
                        VStack {
                            Group {
                                Text("LEVEL UP!")
                                    .font(.custom("PressStart2P-Regular", size: 24))
                                    .padding(.bottom, 5)
                                    .padding(.horizontal, 40)
                                Text("Level \(level.number)")
                                    .font(.custom("PressStart2P-Regular", size: 18))
                                    .padding(.bottom, 5)
                                Text(level.title)
                                    .font(.custom("PressStart2P-Regular", size: 16))
                            }
                            .foregroundStyle(.white)
                            .shadow(color: .white.opacity(0.8), radius: 10, x: 0, y: 0)
                        }
                        .padding()
                        .background(
                            flash ? Color.yellow.opacity(0.4) : Color.black.opacity(0.8)
                        )
                        .cornerRadius(12)
                        .transition(.scale)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                progressManager.didLevelUp = false
                                progressManager.justLeveledTo = nil
                            }
                        }
                        .onAppear {
                            HapticLevelUpModel.playLevelUpHaptic()
                            withAnimation(.easeOut(duration: 0.2)) {
                                flash = true
                            }
                            withAnimation(.easeIn(duration: 0.3).delay(0.2)) {
                                flash = false
                            }
                        }
                    } else {
                        ///normal level up message
                        VStack {
                            Text("LEVEL UP!")
                                .font(.largeTitle)
                                .padding(.bottom, 2)
                                .padding(.horizontal, 40)
                            Text("Level \(level.number)")
                                .font(.title)
                                    .padding(.bottom, 2)
                            Text(level.title)
                                .font(.title2)
                        }
                        .padding()
                        .background(
                            flash ? Color.yellow.opacity(0.4) : Color(colorSettings.secondAccentColor).opacity(0.8)
                        )
                        .cornerRadius(12)
                        .transition(.scale)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                progressManager.didLevelUp = false
                                progressManager.justLeveledTo = nil
                            }
                        }
                        .onAppear {
                            HapticLevelUpModel.playLevelUpHaptic()
                            withAnimation(.easeOut(duration: 0.2)) {
                                flash = true
                            }
                            withAnimation(.easeIn(duration: 0.3).delay(0.2)) {
                                flash = false
                            }
                        }
                    }
                }
            }
            .onAppear {
                if progressManager.unlockedLevels.isEmpty {
                    let currentLevel = progressManager.currentLevel
                    
                    let unlocked = LevelSystem.levels
                        .filter { $0.number < currentLevel.number }
                        .map { $0.number }
                    
                    progressManager.unlockedLevels = Set(unlocked)
                }
            }
        }
            .preferredColorScheme(appearance.mode == .arcade ? .dark : nil)
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
        let appearance = appearanceSettings.first ?? {
            let new = AppearanceSettings()
            context.insert(new)
            try? context.save()
            return new
        }()
        if let existing = mission.completions.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }) {
            mission.completions.removeAll { $0.id == existing.id }
            context.delete(existing)
            try? context.save()
        } else {
            let newCompletion = MissionCompletion(date: selectedDate, mission: mission)
            mission.completions.append(newCompletion)
            
            try? context.save()
            
            DispatchQueue.main.async {
                let didLevelUp = progressManager.checkForLevelUp(missions: missions)
                SoundManager.shared.playSound(
                    named: appearance.mode == .arcade
                        ? (didLevelUp ? "LevelUpArcade" : "AffirmativeArcade")
                        : (didLevelUp ? "LevelUpNormal" : "AffirmativeNormal")
                )
                rumble.impactOccurred()
            }
        }
        print("Checking level. Current:", progressManager.currentLevel.number, "Last:", progressManager.lastLevel.number)

        // ✅ Manually animate points change
        if appearance.mode == .arcade {
            updateBoringPoints()
        } else {
            updateAnimatedPoints()
        }
    }
    
    func updateAnimatedPoints() {
        let newTotal = missions.reduce(0) { total, mission in
            isCompleted(mission) ? total + mission.points : total
        }
            withAnimation(.easeOut(duration: 0.3)) {
                animatedTotalPoints = newTotal
        }
    }
    
    func updateBoringPoints() {
        let newTotal = missions.reduce(0) { total, mission in
            isCompleted(mission) ? total + mission.points : total
        }
            animatedTotalPoints = newTotal
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

//Chat GPT extension to get if conditional working on datepicker text
extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(ProgressManager())
        .modelContainer(Mission.preview)
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
