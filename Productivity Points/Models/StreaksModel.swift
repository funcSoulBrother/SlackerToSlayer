//
//  StreaksModel.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 3/8/26.
//

import Foundation

struct StreakCalculator {
    
    static func completionDays(from completions: [MissionCompletion]) -> [Date] {
        let calendar = Calendar.current
        
        let days = completions.map {
            calendar.startOfDay(for: $0.date)
        }
        
        return Array(Set(days)).sorted()
    }
    
    static func currentStreak(from completions: [MissionCompletion]) -> Int {
        let calendar = Calendar.current
        let days = completionDays(from: completions)
        
        guard !days.isEmpty else { return 0 }
        
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        let startDate: Date
        
        if days.contains(today) {
            startDate = today
        } else if days.contains(yesterday) {
            startDate = yesterday
        } else {
            return 0
        }
        
        var streak = 0
        var currentDate = startDate
        
        while days.contains(currentDate) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        return streak
    }
    
    static func longestStreak(from completions: [MissionCompletion]) -> Int {
        let calendar = Calendar.current
        let days = completionDays(from: completions)
        
        guard !days.isEmpty else { return 0 }
        
        var longest = 1
        var current = 1
        
        for i in 1..<days.count {
            let prev = days[i - 1]
            let currentDay = days[i]
            
            if let diff = calendar.dateComponents([.day], from: prev, to: currentDay).day,
               diff == 1 {
                current += 1
                longest = max(longest, current)
            } else {
                current = 1
            }
        }
        
        return longest
    }
}
