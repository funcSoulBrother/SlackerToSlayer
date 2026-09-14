# Slacker to Slayer

Slacker to Slayer is a native iOS productivity application that turns everyday tasks into a video game. Create daily Missions, earn points for completing them, build streaks, beat your high scores, and level up from Slacker to Slayer.

[![Download on the App Store](./assets/AppStoreBadge.svg)](https://apps.apple.com/us/app/tailwind-guide/id6743378214)

## Overview

I always thought it would be neat to treat life like a video game: the more productive you are, the more points you earn. I decided to turn that idea into Slacker to Slayer.

In Slacker to Slayer, productive tasks are called **Missions**. Create your own Missions, assign them point values, and earn points by completing them throughout the day. Track your high scores and streaks as you work your way through the leveling system, eventually reaching the coveted **Slayer** rank.

## Screenshots

<p align="center">
  <img src="..." width="250">
  <img src="..." width="250">
  <img src="..." width="250">
</p>

## Features

- Create and manage daily Missions
- Assign each Mission a point value manually or through the point questionnaire
- Track completed Missions and daily progress
- Daily and monthly high scores
- Longest streak tracking
- Leveling and prestige system, including Slayer ranks
- 80s arcade-inspired aesthetic with an option for a standard appearance
- Customizable accent colors
- Persistent Mission and progress data using SwiftData

## Technologies

- **Swift/SwiftUI** — Application development and user interface
- **SwiftData** — Persistent storage for Missions and Mission completion data
- **AppStorage** — Persistent storage for lightweight application settings and state
- **Google Mobile Ads SDK** — Displaying banner advertisements

## Architecture

The application uses a SwiftUI-based architecture with separation between views, application logic, and persistent data. MVVM principles are used where appropriate to keep UI presentation and application logic organized.

## Development Highlights

- Designed and developed a complete productivity application using SwiftUI and SwiftData.
- Built persistent Mission and completion tracking using SwiftData.
- Managed application state and lightweight persistent settings using AppStorage.
- Created a cohesive arcade-inspired interface with customizable themes and accent colors.
- Implemented a point-based progression system with daily/monthly high scores, streak tracking, levels, and Slayer prestige ranks.
- Debugged and troubleshot real-world application issues throughout development.
- Managed the App Store submission and review process through App Store Connect.

## Requirements

- Xcode 26.4+
- iOS 26.0+
- macOS 15.0+

## Installation

1. Clone the repository.
2. Open `SideC.xcodeproj` in Xcode.
3. Select a simulator or connected device.
4. Build and run the application.

