//
//  LevelUpOverlay.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 7/25/26.
//

//import SwiftUI
//import SwiftData
//
//struct LevelUpOverlayView: View {
//    @EnvironmentObject var progressManager: ProgressManager
//    let level: Level
//    let appearance: AppearanceSettings
//    let colorSettings: ColorSettings
//    @State private var flash = false
//    
//    var body: some View {
//        
//        if appearance.mode == .arcade {
//            VStack {
//                Group {
//                    Text("LEVEL UP!")
//                        .font(.custom("PressStart2P-Regular", size: 24))
//                        .padding(.bottom, 5)
//                        .padding(.horizontal, 40)
//                    Text("Level \(level.number)")
//                        .font(.custom("PressStart2P-Regular", size: 18))
//                        .padding(.bottom, 5)
//                    Text(level.displayTitle)
//                        .font(.custom("PressStart2P-Regular", size: 16))
//                }
//                .foregroundStyle(.white)
//                .shadow(color: .white.opacity(0.8), radius: 10, x: 0, y: 0)
//            }
//            .padding()
//            .background(
//                flash ? Color.yellow.opacity(0.4) : Color.black.opacity(0.8)
//            )
//            .cornerRadius(12)
//            .transition(.scale)
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
//                    progressManager.didLevelUp = false
//                    progressManager.justLeveledTo = nil
//                }
//            }
//            .onAppear {
//                HapticLevelUpModel.playLevelUpHaptic()
//                withAnimation(.easeOut(duration: 0.2)) {
//                    flash = true
//                }
//                withAnimation(.easeIn(duration: 0.3).delay(0.2)) {
//                    flash = false
//                }
//            }
//        } else {
//            VStack {
//                Text("LEVEL UP!")
//                    .font(.largeTitle)
//                    .padding(.bottom, 2)
//                    .padding(.horizontal, 40)
//                Text("Level \(level.number)")
//                    .font(.title)
//                        .padding(.bottom, 2)
//                Text(level.displayTitle)
//                    .font(.title2)
//            }
//            .padding()
//            .background(
//                flash ? Color.yellow.opacity(0.4) : Color(colorSettings.secondAccentColor).opacity(0.8)
//            )
//            .cornerRadius(12)
//            .transition(.scale)
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//                    progressManager.didLevelUp = false
//                    progressManager.justLeveledTo = nil
//                }
//            }
//            .onAppear {
//                HapticLevelUpModel.playLevelUpHaptic()
//                withAnimation(.easeOut(duration: 0.2)) {
//                    flash = true
//                }
//                withAnimation(.easeIn(duration: 0.3).delay(0.2)) {
//                    flash = false
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    @Environment(\.modelContext) var context
//    @Query var appearanceSettings: [AppearanceSettings]
//    let colorSettings = ColorSettings.shared(in: context)
//    let appearance = appearanceSettings.first ?? {
//        let new = AppearanceSettings()
//        context.insert(new)
//        try? context.save()
//        return new
//    }()
//    LevelUpOverlayView(level: Level(number: 3, precedingSentence: "Your mom is a", title: "Huge Bitch", requiredPoints: 100), appearance: appearance, colorSettings: colorSettings)
//}
