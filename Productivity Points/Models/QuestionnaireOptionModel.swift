//
//  QuestionnaireOptionModel.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 8/2/25.
//

import Foundation

struct QuestionnaireOption: Identifiable, Equatable, Hashable {
    var id = UUID()
    let label: String
    let value: Int
}
