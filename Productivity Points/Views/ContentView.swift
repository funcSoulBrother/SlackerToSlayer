//
//  ContentView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 4/24/25.
//

import SwiftUI
import UserNotifications
import AppTrackingTransparency

struct ContentView: View {
    
        @AppStorage("LastSelectedTab") var savedSelectedTab: Int = 0
        @Environment(ColorSettings.self) var colorSettings
        @EnvironmentObject var appearanceSettings: AppearanceSettings
//        @AppStorage("OnboardingScreenShows") private var willOnboardingScreenShow = true
    var settings = SettingsView()
    
    var body: some View {
        TabView(selection: $savedSelectedTab) {
CalendarHeaderView()
                .tabItem{
                    Label("High Scores", systemImage: "xmark.circle")
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
        .environmentObject(AppearanceSettings())
}

