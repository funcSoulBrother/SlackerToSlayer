//
//  MissionFormView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 7/6/25.
//
import SwiftUI
import SwiftData

struct MissionFormView: View {
    @Environment(\.modelContext) private var modelContext
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
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()
            NavigationStack {
                VStack(spacing: 20) {
                    LabeledContent {
                        TextField("Name", text: $model.name)
                            .textFieldStyle(.roundedBorder)
                    } label: {
                        Text("Name")
                    }
                    Text("Suggestions: \(firstSuggestion), \(secondSuggestion), \(thirdSuggestion)")
                        .foregroundStyle(.secondary)
                        .font(.caption)
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
                        Text("Points (number between 1 and 25)")
                    }
                    Text("Can't decide on a point value? Press this button to help you out!")
                    Button("Generate with Questions") {
                        showingPointsGenerator = true
                    }
                    .sheet(isPresented: $showingPointsGenerator) {
                        ExploringPointsGenerator(points: $model.points)
                    }
                    LabeledContent {
                        ColorPicker("", selection: $model.colorHex, supportsOpacity: false)
                    } label: {
                        Text("Mission Color")
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
                            modelContext.insert(newMission)
                            print("Mission inserted into context")
                            
                            // Force save and check for errors
                            do {
                                try modelContext.save()
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
                    .disabled(model.disabled)
                    .padding(.top)
                    Spacer()
                }
                .padding()
                .navigationTitle(model.updating ? "Edit Mission" : "New Mission")
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
