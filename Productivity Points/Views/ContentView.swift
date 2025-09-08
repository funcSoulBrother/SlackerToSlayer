//
//  ContentView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 4/24/25.
//

import SwiftUI
import SwiftData
import UserNotifications
import AppTrackingTransparency

struct ContentView: View {
    
    @AppStorage("LastSelectedTab") var savedSelectedTab: Int = 0
//        @Environment(ColorSettings.self) var colorSettings
//    @EnvironmentObject var appearanceSettings: AppearanceSettings
    @Environment(\.modelContext) private var context
    @Query private var appearanceSettings: [AppearanceSettings]
//        @Query private var settings: [ColorSettings]
//        @AppStorage("OnboardingScreenShows") private var willOnboardingScreenShow = true
//    var settings = SettingsView()
    private var colorSettings: ColorSettings {
        ColorSettings.shared(in: context)
    }
    
    var body: some View {
///        let appearance = appearanceSettings.first ?? AppearanceSettings()
//        //setting up default accent colors:
//        let colorSettings = settings.first ?? {
//            // If none exist, create one with blue/red
//            let defaults = ColorSettings()
//            context.insert(defaults)
//            try? context.save()
//            return defaults
//        }()
        
        TabView(selection: $savedSelectedTab) {
            HighScoresView()
                .tabItem {
                    Label("High Scores", systemImage: "xmark.circle")
                }
            CalendarHeaderView()
                .tabItem {
                    Label("Monthly Scores", systemImage: "xmark.circle")
                }
                .tag(0)
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "globe")
                }
                .tag(2)
        }
        .onAppear() {
            requestPermissions()
        }

        .accentColor(colorSettings.accentColor)
//        .sheet(isPresented: $willOnboardingScreenShow) {
//            OnboardingScreen(willOnboardingScreenShow: $willOnboardingScreenShow)
//                .interactiveDismissDisabled()
        }
    }

///Will I need notification permission? Probably not. 
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification permission granted")
            } else if let error {
                print(error.localizedDescription)
            }
            
            // After notification permission flow completes (regardless of result),
            // request tracking permission on the main thread with a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if #available(iOS 14, *) {
                    ATTrackingManager.requestTrackingAuthorization { status in
                        switch status {
                        case .authorized:
                            print("Tracking authorization granted")
                        case .denied:
                            print("Tracking authorization denied")
                        case .restricted:
                            print("Tracking restricted")
                        case .notDetermined:
                            print("Tracking not determined")
                        @unknown default:
                            print("Unknown tracking authorization status")
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
        .environment(ColorSettings())
        .environment(AppearanceSettings())
        .modelContainer(Mission.preview)
        .modelContainer(MissionCompletion.preview)
}

