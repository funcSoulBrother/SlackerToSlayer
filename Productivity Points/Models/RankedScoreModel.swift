//
//  Untitled.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 8/24/25.
//

import SwiftUI
import SwiftData

struct RankedScore {
    let rank: Int
    let date: Date
    let totalPoints: Int
    
    static let samples: [RankedScore] = [
        RankedScore(rank: 1, date: .now, totalPoints: 120),
        RankedScore(rank: 2, date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!, totalPoints: 115),
        RankedScore(rank: 3, date: Calendar.current.date(byAdding: .day, value: -2, to: .now)!, totalPoints: 110),
        RankedScore(rank: 4, date: Calendar.current.date(byAdding: .day, value: -3, to: .now)!, totalPoints: 110), // tie with previous
        RankedScore(rank: 5, date: Calendar.current.date(byAdding: .day, value: -4, to: .now)!, totalPoints: 105),
        RankedScore(rank: 6, date: Calendar.current.date(byAdding: .day, value: -5, to: .now)!, totalPoints: 102),
        RankedScore(rank: 7, date: Calendar.current.date(byAdding: .day, value: -6, to: .now)!, totalPoints: 100),
        RankedScore(rank: 8, date: Calendar.current.date(byAdding: .day, value: -7, to: .now)!, totalPoints: 95),
        RankedScore(rank: 9, date: Calendar.current.date(byAdding: .day, value: -8, to: .now)!, totalPoints: 95),  // tie
        RankedScore(rank: 10, date: Calendar.current.date(byAdding: .day, value: -9, to: .now)!, totalPoints: 90),
        RankedScore(rank: 11, date: Calendar.current.date(byAdding: .day, value: -10, to: .now)!, totalPoints: 88),
        RankedScore(rank: 12, date: Calendar.current.date(byAdding: .day, value: -11, to: .now)!, totalPoints: 85),
        RankedScore(rank: 13, date: Calendar.current.date(byAdding: .day, value: -12, to: .now)!, totalPoints: 85), // tie
        RankedScore(rank: 14, date: Calendar.current.date(byAdding: .day, value: -13, to: .now)!, totalPoints: 80),
        RankedScore(rank: 15, date: Calendar.current.date(byAdding: .day, value: -14, to: .now)!, totalPoints: 78),
        RankedScore(rank: 16, date: Calendar.current.date(byAdding: .day, value: -15, to: .now)!, totalPoints: 75),
        RankedScore(rank: 17, date: Calendar.current.date(byAdding: .day, value: -16, to: .now)!, totalPoints: 73),
        RankedScore(rank: 18, date: Calendar.current.date(byAdding: .day, value: -17, to: .now)!, totalPoints: 70),
        RankedScore(rank: 19, date: Calendar.current.date(byAdding: .day, value: -18, to: .now)!, totalPoints: 68),
        RankedScore(rank: 20, date: Calendar.current.date(byAdding: .day, value: -19, to: .now)!, totalPoints: 65)
    ]
}
