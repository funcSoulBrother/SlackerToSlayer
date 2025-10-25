//
//  ContentView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 4/24/25.
//

import SwiftUI
import SwiftData
//import UserNotifications
import AppTrackingTransparency

struct ContentView: View {
    
    @AppStorage("LastSelectedTab") var savedSelectedTab: Int = 2
//        @Environment(ColorSettings.self) var colorSettings
//    @EnvironmentObject var appearanceSettings: AppearanceSettings
    @Environment(\.modelContext) private var context
    @Query private var appearanceSettings: [AppearanceSettings]
//        @Query private var settings: [ColorSettings]
    @AppStorage("OnboardingScreenShows") private var willOnboardingScreenShow = true
//    var settings = SettingsView()
    private var colorSettings: ColorSettings {
        ColorSettings.shared(in: context)
    }
    var previewAppearance: AppearanceSettings?
    
    var body: some View {
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
                    Label("High Scores", systemImage: "trophy.fill")
                }
                .tag(0)
            CalendarHeaderView()
                .tabItem {
                    Label("Monthly Scores", systemImage: "calendar")
                }
                .tag(1)
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .onAppear() {
            print("wow, the view is appearing. Neat!")
            requestPermission()
        }

        .accentColor(colorSettings.accentColor)
        .sheet(isPresented: $willOnboardingScreenShow) {
            OnboardingScreen(willOnboardingScreenShow: $willOnboardingScreenShow)
            //                .interactiveDismissDisabled()
            }
        }
    }

func requestPermission() {
    if #available(iOS 14, *) {
        print("Main thread: \(Thread.isMainThread)")
        DispatchQueue.main.async {
            ATTrackingManager.requestTrackingAuthorization { status in
                print("Status: \(status.rawValue), Main thread in callback: \(Thread.isMainThread)")
            }
        }
    }
}

///Will I need notification permission? Probably not.
//    func requestPermissions() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//            if success {
//                print("Notification permission granted")
//            } else if let error {
//                print(error.localizedDescription)
//            }
//            
//            // After notification permission flow completes (regardless of result),
//            // request tracking permission on the main thread with a delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                if #available(iOS 14, *) {
//                    ATTrackingManager.requestTrackingAuthorization { status in
//                        switch status {
//                        case .authorized:
//                            print("Tracking authorization granted")
//                        case .denied:
//                            print("Tracking authorization denied")
//                        case .restricted:
//                            print("Tracking restricted")
//                        case .notDetermined:
//                            print("Tracking not determined")
//                        @unknown default:
//                            print("Unknown tracking authorization status")
//                    }
//                }
//            }
//        }
//    }
//}


#Preview {
    ContentView(previewAppearance: AppearanceSettings(mode: .arcade))
        .environment(ColorSettings())
        .modelContainer(Mission.preview)
        .modelContainer(MissionCompletion.preview)
}

