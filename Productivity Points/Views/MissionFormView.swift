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
//    @State private var selectingIcon: Bool = false
    @State private var firstSuggestion: String = ""
    @State private var secondSuggestion: String = ""
    @State private var thirdSuggestion: String = ""
    @Query private var appearanceSettings: [AppearanceSettings]
    
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
                    }
                    LabeledContent {
                        TextField("Points", value: $model.points, formatter: intFormatter)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .onChange(of: model.points) { newValue in
                                if model.points > 25 {
                                    model.points = 25
                                } else if model.points < 1 {
                                    model.points = 1
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
                        ExploringPointsGenerator(points: $model.points)
                    }
                    LabeledContent {
                        ColorPicker("", selection: $model.colorHex, supportsOpacity: false)
                    } label: {
                        Text("Color")
                    }
                    .padding(.top)
                    Button(model.updating ? "Update" : "Create") {
                        if model.updating {
                            model.mission?.name = model.name
                            model.mission?.points = model.points
                            model.mission?.colorHex = model.colorHex.toHex()!
                        } else {
                            print("Creating mission: \(model.name), \(model.points) points")
                            let newMission = Mission(
                                id: UUID(),
                                name: model.name,
                                points: model.points,
                                colorHex: model.colorHex.toHex()!
                            )
                            context.insert(newMission)
                            print("Mission inserted into context")
                            
                            // Force save and check for errors
                            do {
                                try context.save()
                                print("Mission saved successfully")
                            } catch {
                                print("Error saving mission: \(error)")
                            }
                        }
                        dismiss()
                    }
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
                }
            }
            /*if selectingIcon {
                ActivityIconSelectionView(selectingIcon: $selectingIcon, selectedIcon: $model.icon)
                    .zIndex(1.0)
            }*/
        }
    }
}




#Preview {
    MissionFormView(model: MissionFormModel())
        .modelContainer(Mission.preview)
}
