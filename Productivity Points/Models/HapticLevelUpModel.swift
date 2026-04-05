//
//  HapticLevelUpModel.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 4/5/26.
//

import CoreHaptics

var engine: CHHapticEngine?

struct HapticLevelUpModel {
    
    static func playLevelUpHaptic() {
        do {
            // Create engine if needed
            if engine == nil {
                engine = try CHHapticEngine()
                try engine?.start()
            }
            
            // Total duration ~2 seconds
            let duration: TimeInterval = 2.0
            
            // Intensity ramps down (taper)
            let intensityCurve = CHHapticParameterCurve(
                parameterID: .hapticIntensityControl,
                controlPoints: [
                    .init(relativeTime: 0.0, value: 1.0),
                    .init(relativeTime: duration, value: 0.1)
                ],
                relativeTime: 0
            )
            
            // Sharpness also softens over time (feels like fading out)
            let sharpnessCurve = CHHapticParameterCurve(
                parameterID: .hapticSharpnessControl,
                controlPoints: [
                    .init(relativeTime: 0.0, value: 0.8),
                    .init(relativeTime: duration, value: 0.2)
                ],
                relativeTime: 0
            )
            
            let intro = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    .init(parameterID: .hapticIntensity, value: 1.0),
                    .init(parameterID: .hapticSharpness, value: 1.0)
                ],
                relativeTime: 0
            )
            
            // Continuous vibration
            let event = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [],
                relativeTime: 0,
                duration: duration
            )
            
            let pattern = try CHHapticPattern(
                events: [intro, event],
                parameterCurves: [intensityCurve, sharpnessCurve]
            )
            
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
            
        } catch {
            print("Haptic error: \(error.localizedDescription)")
        }
    }
}
