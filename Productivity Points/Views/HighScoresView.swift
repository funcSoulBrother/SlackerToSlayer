//
//  HighScoresView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 8/23/25.
//

import SwiftUI
import SwiftData

struct HighScoresView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var progressManager: ProgressManager
    @Query private var appearanceSettings: [AppearanceSettings]
    @Query(sort: \Mission.points) private var missions: [Mission]
    var previewScores: [RankedScore]? = nil
    var previewAppearance: AppearanceSettings?
    var totalPointsEarned: Int {
        missions.reduce(0) { total, mission in
            total + (mission.completions.count * mission.points)
        }
    }
    var rankedTopScores: [RankedScore] {
            if let previewScores {
                return previewScores
            }
        // Step 1: Sum points per day
        var scoreByDate: [Date: Int] = [:]
        for mission in missions {
            for completion in mission.completions {
                let day = Calendar.current.startOfDay(for: completion.date)
                scoreByDate[day, default: 0] += mission.points
            }
        }

        // Step 2: Sort descending by points
        let sortedScores = scoreByDate.sorted {
            if $0.value == $1.value {
                return $0.key > $1.key
            }
            return $0.value > $1.value
        }

        // Step 3: Enumerate and assign ranks with ties
        var previousPoints: Int? = nil
        var previousRank = 0

        return sortedScores.enumerated().compactMap { index, entry in
            let points = entry.value
            let rank = (points == previousPoints) ? previousRank : index + 1
            previousPoints = points
            previousRank = rank
            return rank <= 10 ? RankedScore(rank: rank, date: entry.key, totalPoints: points) : nil
        }
    }

    var body: some View {
        let colorSettings = ColorSettings.shared(in: context)
        let appearance = appearanceSettings.first ?? {
            let new = AppearanceSettings()
            context.insert(new)
            try? context.save()
            return new
        }()
        let currentLevel = LevelSystem.level(for: totalPointsEarned)
        let nextLevel = LevelSystem.nextLevel(after: currentLevel)
        let currentXP = totalPointsEarned - currentLevel.requiredPoints
        let totalXP = nextLevel.requiredPoints - currentLevel.requiredPoints
            ZStack {
                Color(appearance.mode == .arcade ? "ArcadeBG" : "EasyBG")
                    .ignoresSafeArea()
                    VStack {
                        //Level stats
                        if appearance.mode == .arcade {
                            Text("Level \(currentLevel.number)")
                                .font(.custom("PressStart2P-Regular", size: 25))
                                .foregroundStyle(colorSettings.accentColor)
                                .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                                .padding(.top, 15)
                            Text("\(currentLevel.precedingSentence)")
                                .font(.custom("PressStart2P-Regular", size: 13))
                                .foregroundStyle(colorSettings.accentColor)
                                .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                                .padding(.top, 5)
                            Text("\(currentLevel.title)")
                                .font(.custom("PressStart2P-Regular", size: 25))
                                .foregroundStyle(colorSettings.accentColor)
                                .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                                .multilineTextAlignment(.center)
                                .padding(.top, 6)
                                .padding(.bottom, 10)
                        } else {
                            Text("Level \(currentLevel.number)")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .foregroundStyle(colorSettings.accentColor)
                                .padding(.top, 20)
                            Text("\(currentLevel.precedingSentence)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(colorSettings.accentColor)
                            Text("\(currentLevel.title)")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(colorSettings.accentColor)
                                .padding(.bottom, 10)
                        }
                        //Progress bar
                        ProgressView(value: LevelSystem.progress(for: totalPointsEarned))
                            .padding(.horizontal, 20)
                        if appearance.mode == .arcade {
                            if currentLevel.number == nextLevel.number {
                                Text("MAX LEVEL")
                                    .font(.custom("PressStart2P-Regular", size: 25))
                                    .foregroundStyle(colorSettings.accentColor)
                                    .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                                    .padding(.top, 5)
                            } else {
                                Text("\(currentXP) / \(totalXP) XP")
                                    .font(.custom("PressStart2P-Regular", size: 25))
                                    .foregroundStyle(colorSettings.accentColor)
                                    .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                                    .padding(.top, 5)
                            }
                        } else {
                            if currentLevel.number == nextLevel.number {
                                Text("MAX LEVEL")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(colorSettings.accentColor)
                                    .padding(.top, 5)
                            } else {
                                Text("\(currentXP) / \(totalXP) XP")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(colorSettings.accentColor)
                                    .padding(.top, 5)
                            }
                        }
                        //All Points Ever
                        if appearance.mode == .arcade {
                            Text("Total Points:")
                                .font(.custom("PressStart2P-Regular", size: 25))
                                .foregroundStyle(colorSettings.accentColor)
                                .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 5)
                                .padding(.top, 10)
                            Text("\(totalPointsEarned)")
                                .font(.custom("PressStart2P-Regular", size: 25))
                                .foregroundStyle(colorSettings.accentColor)
                                .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                        } else {
                            Text("Total Points:")
                                .font(.title)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(colorSettings.accentColor)
                                .padding(.top, 5)
                            Text("\(totalPointsEarned)")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .foregroundStyle(colorSettings.accentColor)
//                                .padding(.bottom, 5)
                        }
                        //Top 10
                        if appearance.mode == .arcade {
                            Text("High Scores")
                                .font(.custom("PressStart2P-Regular", size: 25))
                                .foregroundStyle(colorSettings.secondAccentColor)
                                .shadow(color: colorSettings.secondAccentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                                .multilineTextAlignment(.center)
                                .padding(.top, 30)
                                .padding()
                        } else {
                            Divider()
                                .padding(.horizontal, 10)
                            Text("Top 10 Days")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(colorSettings.secondAccentColor)
//                                .padding(.top, 10)
                                .padding(.bottom, 10)
                        }
                        if rankedTopScores.isEmpty {
                            Text("You haven't done anything yet so there are no high scores. Get out there and do stuff!")
                                .monospaced()
                                .padding(.horizontal, 30)
//                            ContentUnavailableView("You haven't done anything yet so there are no high scores. Get out there and do stuff!", systemImage: "figure.run")
                        } else {
                            ForEach(rankedTopScores.prefix(10), id: \.date) { score in
                                HStack {
                                    // Rank column
                                    Text("\(score.rank).")
                                        .bold()
                                        .frame(width: 40, alignment: .leading)
                                        .monospaced()
                                    // Date column
                                    Text(score.date.formatted(.dateTime.month().day().year()))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .monospaced()
                                    // Points column (right aligned)
                                    Text("\(score.totalPoints) pts")
                                        .frame(width: 100, alignment: .trailing)
                                        .monospaced()
                                }
                                .font(.headline)
                                .padding(.horizontal, 25)
                            }
                        }
                        Spacer()
                    }
                    .foregroundStyle(colorSettings.secondAccentColor)
                }
            }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy" // Aug 23, 2025
        return formatter.string(from: date)
    }
}

#Preview {
    HighScoresView(previewScores: RankedScore.samples, previewAppearance: AppearanceSettings(mode: .arcade))
        .environmentObject(ProgressManager())

//    HighScoresView(previewScores: RankedScore.samples)
////        .modelContainer(MissionCompletion.preview)
//        .environment(AppearanceSettings())
//        .environment(ColorSettings())
////        .modelContainer(Mission.preview)
}
