//
//  LevelModel.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 3/3/26.
//
import Foundation

struct Level: Equatable {
    let number: Int
    let precedingSentence: String
    let title: String
    let requiredPoints: Int
    var displayTitle: String {
        guard title == "Slayer" else {
            return title
        }
        guard number > 21 else {
            return "Slayer"
        }
        return "Slayer \((number - 20).romanNumeral)"
    }
}

struct LevelSystem {
    static let finalNormalLevel = 20
    static let firstSlayerLevel = 21
    static let prestigePointsPerLevel = 350
    
    static let levels: [Level] = [
        Level(number: 1, precedingSentence: "You're just a", title: "Slacker", requiredPoints: 0),
        Level(number: 2, precedingSentence: "You are a", title: "Napping Novice", requiredPoints: 25),
        Level(number: 3, precedingSentence: "You are a", title: "Busy Beginner", requiredPoints: 55),
        Level(number: 4, precedingSentence: "You are a", title: "Chore Chump", requiredPoints: 90),
        Level(number: 5, precedingSentence: "You are a", title: "Fruitful Fanatic", requiredPoints: 130),
        Level(number: 6, precedingSentence: "You are a", title: "Procrastination Pulverizer", requiredPoints: 180),
        Level(number: 7, precedingSentence: "You are a", title: "Focus Warrior", requiredPoints: 240),
        Level(number: 8, precedingSentence: "You are a", title: "Glorious Go-Getter", requiredPoints: 315),
        Level(number: 9, precedingSentence: "You are a", title: "Task Terminator", requiredPoints: 405),
        Level(number: 10, precedingSentence: "You are an", title: "Effort Expert", requiredPoints: 510),
        Level(number: 11, precedingSentence: "You are a", title: "Giver of 110%", requiredPoints: 630),
        Level(number: 12, precedingSentence: "You are a", title: "Serial Achiever", requiredPoints: 770),
        Level(number: 13, precedingSentence: "You are a", title: "To-Do List Annihilator", requiredPoints: 930),
        Level(number: 14, precedingSentence: "You are a", title: "Hustlin' Hero", requiredPoints: 1115),
        Level(number: 15, precedingSentence: "You are a", title: "Chore Champ", requiredPoints: 1325),
        Level(number: 16, precedingSentence: "You are a", title: "Hyperefficient Lieutenant", requiredPoints: 1560),
        Level(number: 17, precedingSentence: "You are the", title: "Mayor of Diligentopia", requiredPoints: 1820),
        Level(number: 18, precedingSentence: "You are the", title: "Patron Saint of Productivity", requiredPoints: 2105),
        Level(number: 19, precedingSentence: "You are a", title: "Self-Actualizing Sensation", requiredPoints: 2415),
        Level(number: 20, precedingSentence: "You are the", title: "Mission Master", requiredPoints: 2750)
    ]
    
    static var finalNormalLevelData: Level {
            levels.last!
        }
    
    private static func slayerLevel(number: Int, requiredPoints: Int) -> Level {
        Level(number: number, precedingSentence: "You are a", title: "Slayer", requiredPoints: requiredPoints)
    }

        static func level(for points: Int) -> Level {

            let finalLevel = finalNormalLevelData

            // Haven't reached Slayer yet.
            if points < finalLevel.requiredPoints + prestigePointsPerLevel {
                return levels.last(where: {
                    points >= $0.requiredPoints
                }) ?? levels[0]
            }

            // Figure out which Slayer level we're on.
            let slayerStartPoints = finalLevel.requiredPoints + prestigePointsPerLevel

            let prestigeIndex =
                (points - slayerStartPoints) / prestigePointsPerLevel

            return slayerLevel(
                number: firstSlayerLevel + prestigeIndex,
                requiredPoints: slayerStartPoints + prestigeIndex * prestigePointsPerLevel
            )
        }

        static func nextLevel(after level: Level) -> Level {

            if level.number <= finalNormalLevel {

                guard let index = levels.firstIndex(where: {
                    $0.number == level.number
                }) else {
                    return level
                }

                if index < levels.count - 1 {
                    return levels[index + 1]
                }

                // Level 20 -> Level 21 (Slayer)
                return slayerLevel(
                    number: firstSlayerLevel,
                    requiredPoints: level.requiredPoints + prestigePointsPerLevel
                )
            }

            // Slayer II, III, IV...
            return slayerLevel(
                number: level.number + 1,
                requiredPoints: level.requiredPoints + prestigePointsPerLevel
            )
        }

        static func progress(for points: Int) -> Double {

            let current = level(for: points)
            let next = nextLevel(after: current)

            return Double(points - current.requiredPoints) /
                Double(next.requiredPoints - current.requiredPoints)
        }
    }
