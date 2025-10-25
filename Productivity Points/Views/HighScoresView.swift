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
//    @EnvironmentObject var appearanceSettings: AppearanceSettings
//    @Environment(ColorSettings.self) var colorSettings
//    @State private var monthDate = Date.now
//    @State private var years: [Int] = []
//    @State private var selectedMonth = Date.now.monthInt
//    @State private var selectedYear = Date.now.yearInt
//    let months = Date.fullMonthNames
//    @Query private var missionCompletions: [MissionCompletion]
    @Query private var appearanceSettings: [AppearanceSettings]
    @Query(sort: \Mission.points) private var missions: [Mission]
//    @Query private var settings: [ColorSettings]
    var previewScores: [RankedScore]? = nil
    var previewAppearance: AppearanceSettings?
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
            ZStack {
                Color(appearance.mode == .arcade ? "ArcadeBG" : "EasyBG")
                    .ignoresSafeArea()
                    VStack {
                        if appearance.mode == .arcade {
                            Text("Top 10 High Scores")
                                .font(.custom("PressStart2P-Regular", size: 25))
                                .foregroundStyle(colorSettings.accentColor)
                                .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                                .multilineTextAlignment(.center)
                                .padding()
                        } else {
                            Text("Top 10 Days")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(colorSettings.accentColor)
                                .padding(.bottom, 40)
                        }
                        if rankedTopScores.isEmpty {
                            ContentUnavailableView("You haven't done anything yet so there are no high scores. Get out there and do stuff!", systemImage: "figure.run")
                        } else {
                            ForEach(rankedTopScores.prefix(10), id: \.date) { score in
                                HStack {
                                    Text("\(score.rank).")
                                        .bold()
                                        .font(.title3)
                                    Text("\(score.date.formatted(.dateTime.month().day().year())) - \(score.totalPoints) pts")
                                        .font(.title3)
                                        Spacer()
                                }
                                .padding(.leading, 50)
                            }
                        }
                        Spacer()
                    }
                    .foregroundStyle(colorSettings.accentColor)
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

//    HighScoresView(previewScores: RankedScore.samples)
////        .modelContainer(MissionCompletion.preview)
//        .environment(AppearanceSettings())
//        .environment(ColorSettings())
////        .modelContainer(Mission.preview)
}
