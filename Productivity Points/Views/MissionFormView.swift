//
//  MissionFormView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 7/6/25.
//
import SwiftUI
import SwiftData

struct MissionFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State var model: MissionFormModel
    @State private var showingPointsGenerator = false
    private let intFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter }()
    @State private var pointsText: String = ""
    @State private var firstSuggestion: String = ""
    @State private var secondSuggestion: String = ""
    @State private var thirdSuggestion: String = ""
    @Query private var appearanceSettings: [AppearanceSettings]
    let colors: [Color] = [
        .blue, .mint, .green,
        .yellow, .orange, .red, .pink, .purple, .indigo
    ]
    
    func getThreeUniqueSuggestions() {
        firstSuggestion = RandomMissionSuggestions.all.randomElement()!
        repeat {
            secondSuggestion = RandomMissionSuggestions.all.randomElement()!
        } while secondSuggestion == firstSuggestion
        repeat {
            thirdSuggestion = RandomMissionSuggestionsPlusStupid.all.randomElement()!
        } while thirdSuggestion == firstSuggestion || thirdSuggestion == secondSuggestion
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
            Color(UIColor.systemBackground).ignoresSafeArea()
            NavigationStack {
                VStack(spacing: 20) {
                    if appearance.mode == .arcade {
                        Text(model.updating ? "Edit Mission" : "New Mission")
                            .font(.custom("PressStart2P-Regular", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(colorSettings.accentColor)
                            .shadow(color: colorSettings.accentColor.opacity(0.8), radius: 10, x: 0, y: 0)
                            .padding()
                    } else {
                        Text(model.updating ? "Edit Mission" : "New Mission")
                            .font(.title)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(colorSettings.accentColor)
                    }
                    LabeledContent {
                        TextField("Name", text: $model.name)
                            .textFieldStyle(.roundedBorder)
                    } label: {
                        Text("Name")
                    }
                    if !model.updating {
                        Text("Suggestions: \(firstSuggestion), \(secondSuggestion), \(thirdSuggestion)")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                    }
                    LabeledContent {
                        TextField("Points", text: $pointsText)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .onChange(of: pointsText) { newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered != newValue {
                                    pointsText = filtered
                                    return
                                }
                                if let value = Int(filtered) {
                                    let clamped = min(max(value, 1), 25)
                                    model.points = clamped
                                    pointsText = String(clamped)
                                } else {
                                    model.points = nil
                                }
                            }
                    } label: {
                        Text("Points (1 - 25)")
                    }
                    Text("Can't decide on a point value? Press the button below to help you out!")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                    Button("Point Questionnaire") {
                        showingPointsGenerator = true
                    }
                    .padding(6)
                    .font(.footnote)
                    .foregroundStyle(.primary)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(6)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .sheet(isPresented: $showingPointsGenerator) {
                        ExploringPointsGenerator(
                            points: Binding(
                                get: { model.points ?? 1 },
                                set: { newValue in
                                    model.points = newValue
                                    pointsText = String(newValue)
                                }
                            )
                        )
                    }
                    LabeledContent {
                        ColorPicker("", selection: $model.colorHex, supportsOpacity: false)
                    } label: {
                        Text("Color")
                    }
                    .padding(.top)
                    HStack(spacing: 12) {
                        ForEach(colors, id: \.self) { color in
                            ColorButton(
                                color: color,
                                selectedColor: $model.colorHex
                            )
                        }
                    }
                    Button(model.updating ? "Update" : "Create") {
                        guard let points = model.points else {
                            return
                        }

                        if model.updating {
                            model.mission?.name = model.name
                            model.mission?.points = points
                            model.mission?.colorHex = model.colorHex.toHex()!
                        } else {
                            print("Creating mission: \(model.name), \(points) points")

                            let newMission = Mission(
                                id: UUID(),
                                name: model.name,
                                points: points,
                                colorHex: model.colorHex.toHex()!
                            )

                            context.insert(newMission)

                            do {
                                try context.save()
                                print("Mission saved successfully")
                            } catch {
                                print("Error saving mission: \(error)")
                            }
                        }

                        dismiss()
                    }
                    .disabled(model.disabled)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
                    .buttonStyle(.borderedProminent)
                    .tint(colorSettings.accentColor)
                    .disabled(model.disabled)
                    .padding(.top)
                    Spacer()
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    getThreeUniqueSuggestions()
                    pointsText = model.points.map { String($0) } ?? ""
                }
            }
        }
    }
}




#Preview {
    MissionFormView(model: MissionFormModel())
        .modelContainer(Mission.preview)
}
