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
}

struct LevelSystem {
    
    static let levels: [Level] = [
        Level(number: 1, precedingSentence: "You are a", title: "Fucking Retard", requiredPoints: 0),
        Level(number: 2, precedingSentence: "You are an", title: "Intermediate Task Doer", requiredPoints: 1),
        Level(number: 3, precedingSentence: "Your mom is a", title: "Focus Warrior", requiredPoints: 2),
        Level(number: 4, precedingSentence: "You are the", title: "Mission Master", requiredPoints: 3)
    ]
    
    static var maxLevel: Level {
        levels.last!
    }
    
    static func level(for points: Int) -> Level {
        levels
            .last(where: { points >= $0.requiredPoints }) ?? levels[0]
    }
    
    static func nextLevel(after level: Level) -> Level {
        guard let index = levels.firstIndex(where: { $0.number == level.number }) else {
            return level
        }
        if index < levels.count - 1 {
            return levels[index + 1]
        } else {
            return level // already max
        }
    }
    
    static func progress(for points: Int) -> Double {
        let currentLevel = LevelSystem.level(for: points)
        guard let currentIndex = LevelSystem.levels.firstIndex(where: { $0.number == currentLevel.number }) else {
            return 0
        }
        // If it's the last level, you're full
        if currentIndex == LevelSystem.levels.count - 1 {
            return 1.0
        }
        let nextLevel = LevelSystem.levels[currentIndex + 1]
        let progress = Double(points - currentLevel.requiredPoints) /
                       Double(nextLevel.requiredPoints - currentLevel.requiredPoints)
        return min(max(progress, 0), 1)
    }
    
}
