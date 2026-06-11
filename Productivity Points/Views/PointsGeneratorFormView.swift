//
//  ExploringPointsGenerator.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 7/13/25.
//

import SwiftUI
import SwiftData

let howLong = [
    QuestionnaireOption(label: "Quick", value: 1),
    QuestionnaireOption(label: "Pretty Long", value: 2),
    QuestionnaireOption(label: "All Day", value: 3)
]

let howEnjoyable = [
    QuestionnaireOption(label: "Not Very Enjoyable", value: 20),
    QuestionnaireOption(label: "Very Enjoyable", value: 10)
]

let howAligned = [
    QuestionnaireOption(label: "Not Really", value: 1),
    QuestionnaireOption(label: "Kind Of", value: 2),
    QuestionnaireOption(label: "Yes, Very", value: 3)
]

struct ExploringPointsGenerator: View {
    @Environment(\.modelContext) private var context
    @Binding var points: Int
    @Environment(\.dismiss) var dismiss
    @State private var selectedA: QuestionnaireOption = howLong[0]
    @State private var selectedB: QuestionnaireOption = howEnjoyable[0]
    @State private var selectedC: QuestionnaireOption = howAligned[0]
    @Query private var appearanceSettings: [AppearanceSettings]
    private var tempResult: Int {
        PointCalculator.calculatePoints(
            a: selectedA,
            b: selectedB,
            c: selectedC
        )
    }

    var body: some View {
        let colorSettings = ColorSettings.shared(in: context)
        let appearance = appearanceSettings.first ?? {
            let new = AppearanceSettings()
            context.insert(new)
            try? context.save()
            return new
        }()
        VStack(spacing: 20) {
            if appearance.mode == .arcade {
                Text("Points Generator")
                    .font(.custom("PressStart2P-Regular", size: 18))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(colorSettings.accentColor)
                    .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                    .padding()
            } else {
                Text("Points Generator")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(colorSettings.accentColor)
            }
            
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
                Text("How enjoyable do you find this task?")
                Picker("How Enjoyable", selection: $selectedB) {
                    ForEach(howEnjoyable) { option in
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
            Text("Current Point Value: \(tempResult)")
                .fontWeight(.bold)
            Button("Use This Point Value!") {
                points = tempResult
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(colorSettings.accentColor)
        }
        .padding()
    }
}

#Preview {
    ExploringPointsGenerator(points: .constant(10))
}
