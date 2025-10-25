//
//  PointsCalculator.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 8/3/25.
//

import Foundation

struct PointCalculator {
    static func calculatePoints(
        a: QuestionnaireOption,
        b: QuestionnaireOption,
        c: QuestionnaireOption
    ) -> Int {
        if a.label == "Possibly All Day" {
            return 20
        } else if a.label == "Quick" && b.label == "Not Very Enjoyable" && c.label == "Not Really" {
            return 2
        } else if a.label == "Quick" && b.label == "Not Very Enjoyable" && c.label == "Kind Of" {
            return 3
        } else if a.label == "Quick" && b.label == "Not Very Enjoyable" && c.label == "Yes, Very" {
            return 4
        } else if a.label == "Quick" && b.label == "Very Enjoyable" && c.label == "Not Really" {
            return 1
        } else if a.label == "Quick" && b.label == "Very Enjoyable" && c.label == "Kind Of" {
            return 2
        } else if a.label == "Quick" && b.label == "Very Enjoyable" && c.label == "Yes, Very" {
            return 3
        } else if a.label == "Pretty Long" && b.label == "Not Very Enjoyable" && c.label == "Not Really" {
            return 4
        } else if a.label == "Pretty Long" && b.label == "Not Very Enjoyable" && c.label == "Kind Of" {
            return 5
        } else if a.label == "Pretty Long" && b.label == "Not Very Enjoyable" && c.label == "Yes, Very" {
            return 6
        } else if a.label == "Pretty Long" && b.label == "Very Enjoyable" && c.label == "Not Really" {
            return 3
        } else if a.label == "Pretty Long" && b.label == "Very Enjoyable" && c.label == "Kind Of" {
            return 4
        } else if a.label == "Pretty Long" && b.label == "Very Enjoyable" && c.label == "Yes, Very" {
            return 5
        }

        return 0
    }
}
