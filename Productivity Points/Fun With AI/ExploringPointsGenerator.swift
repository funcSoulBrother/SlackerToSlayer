//
//  ExploringPointsGenerator.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 7/13/25.
//

import SwiftUI

// Struct for options
struct QuestionnaireOption: Identifiable, Equatable, Hashable {
    var id = UUID()
    let label: String
    let value: Int
}

// Static options (defined once, not on every redraw)
let howLong = [
    QuestionnaireOption(label: "Quick", value: 1),
    QuestionnaireOption(label: "Pretty Long", value: 2),
    QuestionnaireOption(label: "Possibly All Day", value: 3)
]

let howMotivated = [
    QuestionnaireOption(label: "Not Very Motivated", value: 20),
    QuestionnaireOption(label: "Very Motivated", value: 10)
]

let howAligned = [
    QuestionnaireOption(label: "Not Really", value: 1),
    QuestionnaireOption(label: "Kind of", value: 2),
    QuestionnaireOption(label: "Yes, Very", value: 3)
]

struct ExploringPointsGenerator: View {
    @Binding var points: Int
    @Environment(\.dismiss) var dismiss
    @State private var selectedA: QuestionnaireOption = howLong[0]
    @State private var selectedB: QuestionnaireOption = howMotivated[0]
    @State private var selectedC: QuestionnaireOption = howAligned[0]
    private var tempResult: Int { selectedA.value * selectedB.value * selectedC.value }

    var body: some View {
        VStack(spacing: 20) {
            Text("Point Questionnaire")
                .font(.title2)
                .bold()
            
            VStack {
                Text("How long does this task usually take?")
                Picker("How Long", selection: $selectedA) {
                    ForEach(howLong) { option in
                        Text(option.label).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            
            VStack {
                Text("How motivated are you to do this task?")
                Picker("How Motivated", selection: $selectedB) {
                    ForEach(howMotivated) { option in
                        Text(option.label).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            
            VStack {
                Text("Does this task align well with your goals?")
                Picker("How Aligned", selection: $selectedC) {
                    ForEach(howAligned) { option in
                        Text(option.label).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            
            Button("Calculate") {
                points = tempResult
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            
            Text("Current Point Value: \(tempResult)")
        }
        .padding()
    }
}

#Preview {
    ExploringPointsGenerator(points: .constant(10))
}
