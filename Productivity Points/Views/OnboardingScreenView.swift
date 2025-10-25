//
//  OnboardingScreenView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 10/1/25.
//

import SwiftUI

struct OnboardingScreen: View {
    @Binding var willOnboardingScreenShow: Bool
    
    var body: some View {
        ZStack {
            Color("ArcadeBG")
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .center) {
                    Text("Welcome to Productivity Points!")
                        .font(.custom("PressStart2P-Regular", size: 25))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.blue)
                        .shadow(color: .blue.opacity(0.8), radius: 10, x: 0, y: 0)
                        .padding()
                }
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName: "map.fill")
                            .font(.title)
                            .foregroundStyle(.arcadeBG)
                        Text("A productivity app that lets you give yourself points for tasks you want to do every day. Beat your high score!")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundStyle(.blue)
                    }
                    .padding()
                    HStack{
                        Image(systemName: "star")
                            .font(.title)
                            .foregroundStyle(.white)
                        Text("Think of tasks you want to do every day. These are called Missions in Productivity Points. Add a mission by hitting the \(Image(systemName: "plus.circle.fill")) button on top of the home screen. Once you’ve completed a mission, simply check it off the list.")
                            .font(.title3)
                            .fontWeight(.light)
                    }
                    .padding()
                    HStack{
                        Image(systemName: "paintpalette")
                            .font(.title)
                            .foregroundColor(.white)
                        Text("Go to the Settings tab to customize the look of Productivity Points.")
                            .font(.title3)
                            .fontWeight(.light)
                    }
                    .padding()
                    HStack{
                        Image(systemName: "trophy")
                            .font(.title)
                            .foregroundColor(.white)
                        Text("Go to the High Scores or Monthly Scores tabs to look back on your achievements!")
                            .font(.title3)
                            .fontWeight(.light)
                    }
                    .padding()
                }
                    .foregroundStyle(.white)
                VStack(alignment: .center){
                    Button(action: { willOnboardingScreenShow.toggle()}) {
                        Text("Press Start")
                            .padding()
                            .font(.custom("PressStart2P-Regular", size: 20))
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingScreen(willOnboardingScreenShow: .constant(true))
}
