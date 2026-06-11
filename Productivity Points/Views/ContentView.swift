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
import AdSupport

struct ContentView: View {
    
    @AppStorage("LastSelectedTab") var savedSelectedTab: Int = 0
    @Environment(\.modelContext) private var context
    @Query private var appearanceSettings: [AppearanceSettings]
    @AppStorage("OnboardingScreenShows") private var willOnboardingScreenShow = true
    private var colorSettings: ColorSettings {
        ColorSettings.shared(in: context)
    }
    var previewAppearance: AppearanceSettings?
    
    var body: some View {
        
        TabView(selection: $savedSelectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            CalendarHeaderView()
                .tabItem {
                    Label("Monthly + Streaks", systemImage: "calendar")
                }
                .tag(1)
            HighScoresView()
                .tabItem {
                    Label("High Scores", systemImage: "trophy.fill")
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .onAppear {
            // Small delay to let UI settle
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                requestTrackingPermission()
            }
        }

        .accentColor(colorSettings.accentColor)
        .sheet(isPresented: $willOnboardingScreenShow) {
            OnboardingScreen(willOnboardingScreenShow: $willOnboardingScreenShow)
            //                .interactiveDismissDisabled()
            }
        }
    }

func requestTrackingPermission() {
    // Only request on iOS 14.5+
    if #available(iOS 14.5, *) {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("Tracking authorized")
                // You can now access IDFA
                let idfa = ASIdentifierManager.shared().advertisingIdentifier
                print("IDFA: \(idfa)")
            case .denied:
                print("Tracking denied")
            case .notDetermined:
                print("Tracking not determined")
            case .restricted:
                print("Tracking restricted")
            @unknown default:
                print("Unknown tracking status")
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
        .environmentObject(ProgressManager())
        .environment(ColorSettings())
        .modelContainer(Mission.preview)
        .modelContainer(MissionCompletion.preview)
}

