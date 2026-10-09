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
    @State private var selectedDate = Date()
    @State private var modalType: ModalType?
    @State private var showMissionDeleteAlert = false
    @State private var missionToDelete: Mission?
    @State private var flash = false
    @Query private var appearanceSettings: [AppearanceSettings]
    @Query(sort: \Mission.points) private var missions: [Mission]
    let rumble = UIImpactFeedbackGenerator(style: .medium)
    var previewAppearance: AppearanceSettings?
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
            ZStack(alignment: .bottomTrailing) {
                Color(appearance.mode == .arcade ? "ArcadeBG" : "EasyBG")
                    .ignoresSafeArea()
                Group {
                    if missions.isEmpty {
                        VStack() {
                            Image("icon-transparent")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                            Text("Create your first Mission by tapping on the \(Image(systemName: "plus.circle.fill")) button at the bottom right corner.")
                                .foregroundStyle(colorSettings.accentColor)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
//                            ContentUnavailableView("Create your first Mission by tapping on the \(Image(systemName: "plus.circle.fill")) button at the bottom right corner.", image: "icon-transparent")
//                                .foregroundStyle(colorSettings.accentColor)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 100)
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
                                    .padding(.horizontal, 7)
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
                                        .foregroundStyle(colorSettings.accentColor)
                                        .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 20)
                                        .padding(.leading)
                            } else {
                                Text("Total Points: \(animatedTotalPoints)")
                                    .font(.largeTitle)
                                    .padding(.bottom, 5)
                                    .foregroundStyle(colorSettings.accentColor)
                                    .monospacedDigit()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 20)
                                    .padding(.leading)
                            }
                            ZStack(alignment: .top) {
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
                                if progressManager.didLevelUp,
                                   let level = progressManager.justLeveledTo {
                                    if appearance.mode == .arcade {
                                        VStack {
                                                if level.isSlayer {
                                                    Group {
                                                        Text("YOU ARE NOW A SLAYER!")
                                                            .font(.custom("PressStart2P-Regular", size: 24))
                                                            .padding(.bottom, 20)
                                                        Text("Through consistency and determination,")
                                                        Text("you've transformed yourself")
                                                        Text("from a Slacker into a Slayer.")
                                                        Spacer()
                                                            .frame(height: 15)
                                                        Text("Your journey doesn't end here.")
                                                        Text("It enters a new chapter.")
                                                        Spacer()
                                                            .frame(height: 15)
                                                        Text("Welcome to the ranks")
                                                        Text("of the Slayers.")
                                                    }
                                                    .font(.footnote)
                                                    .multilineTextAlignment(.center)
                                                    .foregroundStyle(.yellow)
                                                    .shadow(color: .yellow.opacity(0.8), radius: 10, x: 0, y: 0)
                                                } else {
                                                    Group {
                                                        Text("LEVEL UP!")
                                                            .font(.custom("PressStart2P-Regular", size: 24))
                                                            .padding(.bottom, 5)
                                                            .padding(.horizontal, 40)
                                                        Text("Level \(level.number)")
                                                            .font(.custom("PressStart2P-Regular", size: 18))
                                                            .padding(.bottom, 5)
                                                        Text(level.displayTitle)
                                                            .font(.custom("PressStart2P-Regular", size: 16))
                                                    }
                                                    .foregroundStyle(.white)
                                                    .shadow(color: .white.opacity(0.8), radius: 10, x: 0, y: 0)
                                                }
                                        }
                                        .padding()
                                        .background(
                                            flash ? Color.yellow.opacity(0.4) : Color.black.opacity(0.8)
                                        )
                                        .cornerRadius(12)
                                        .transition(.scale)
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + (level.number == LevelSystem.firstSlayerLevel ? 20 : 5)) {
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
                                        VStack {
                                            if level.isSlayer {
                                                Text("YOU ARE NOW A SLAYER!")
                                                    .font(.largeTitle)
                                                    .multilineTextAlignment(.center)
                                                    .padding(.bottom, 20)
                                                    .foregroundStyle(.black)
                                                    .fontWeight(.bold)
                                                Group {
                                                    Text("Through consistency and determination,")
                                                    Text("you've transformed yourself")
                                                    Text("from a Slacker into a Slayer.")
                                                    Spacer()
                                                        .frame(height: 15)
                                                    Text("Your journey doesn't end here.")
                                                    Text("It enters a new chapter.")
                                                    Spacer()
                                                        .frame(height: 15)
                                                    Text("Welcome to the ranks")
                                                    Text("of the Slayers.")
                                                }
                                                .font(.footnote)
                                                .foregroundStyle(.black)
                                            } else {
                                                Group {
                                                    Text("LEVEL UP!")
                                                        .font(.largeTitle)
                                                        .fontWeight(.bold)
                                                        .padding(.bottom, 2)
                                                        .padding(.horizontal, 40)
                                                    Text("Level \(level.number)")
                                                        .font(.title)
                                                        .padding(.bottom, 2)
                                                    Text(level.displayTitle)
                                                        .font(.title2)
                                                }
                                                .foregroundStyle(.white)
                                            }
                                        }
                                        .padding()
                                        .background(level.isSlayer ? (flash ? Color.blue.opacity(0.8) : Color.yellow.opacity(0.8)) : (flash ? Color.yellow.opacity(0.4) : Color.black.opacity(0.8)))
                                        .cornerRadius(12)
                                        .transition(.scale)
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + (level.number == LevelSystem.firstSlayerLevel ? 20 : 5)) {
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
                        }
                        .task {
                            if appearance.mode == .arcade {
                                updateBoringPoints()
                            } else {
                                updateAnimatedPoints()
                            }
                        }
                        .onChange(of: selectedDate) {
                            if appearance.mode == .arcade {
                                updateBoringPoints()
                            } else {
                                updateAnimatedPoints()
                            }

                        }
                    }
                }
                .toolbar {
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
                
                if progressManager.didLevelUp,
                   let level = progressManager.justLeveledTo {
                    ConfettiView(colors: level.isSlayer ? [.yellow] : [.red, .yellow, .green, .blue, .pink, .purple])
                }
                Button {
                    modalType = .newMission
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(colorSettings.accentColor)
                }
                .padding(.trailing, 30)
                .padding(.bottom, 70)
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
            .safeAreaInset(edge: .bottom) {
                AdBannerView()
                    .frame(width: 320, height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color(appearance.mode == .arcade ? "ArcadeBG" : "EasyBG"))
                    .padding(.bottom, 10)
            }
    }

    // Check if a completion exists for selectedDate
    func isCompleted(_ mission: Mission) -> Bool {
        mission.completions.contains { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

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
                let soundName: String
                if didLevelUp {
                    if progressManager.justLeveledTo?.isSlayer == true {
                        soundName = appearance.mode == .arcade
                            ? "LevelUpArcadeSlayer"
                            : "LevelUpNormalSlayer"
                    } else {
                        soundName = appearance.mode == .arcade
                            ? "LevelUpArcade"
                            : "LevelUpNormal"
                    }
                } else {
                    soundName = appearance.mode == .arcade
                        ? "AffirmativeArcade"
                        : "AffirmativeNormal"
                }

                SoundManager.shared.playSound(named: soundName)
                rumble.impactOccurred()
            }
        }
        print("Checking level. Current:", progressManager.currentLevel.number, "Last:", progressManager.lastLevel.number)

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

extension Level {
    var isSlayer: Bool {
        number == LevelSystem.firstSlayerLevel
    }
}


#Preview {
    HomeView()
        .environmentObject(ProgressManager())
        .modelContainer(Mission.preview)
        .environment(ColorSettings())
}

