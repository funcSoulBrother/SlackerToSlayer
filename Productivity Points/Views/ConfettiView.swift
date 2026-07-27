//
//  ConfettiView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 3/24/26.
//

import SwiftUI

struct ConfettiView: View {
    @State private var pieces: [ConfettiPiece] = []
    @State private var spawnedCount = 0

    let maxPieces = 225
    let colors: [Color]
//    let colors: [Color] = [.red, .yellow, .green, .blue, .pink, .purple]

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { timeline in
                
                Canvas { context, size in
                    // DRAW ONLY
                    for piece in pieces {
                        let rect = CGRect(
                            x: piece.x,
                            y: piece.y,
                            width: piece.size,
                            height: piece.size
                        )

                        context.fill(
                            Path(roundedRect: rect, cornerRadius: 2),
                            with: .color(piece.color)
                        )
                    }
                }
                // ✅ THIS is where updates happen
                .task(id: timeline.date) {
                    updateConfetti(in: geo.size)
                    spawnConfetti(in: geo.size)
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

extension ConfettiView {
    func spawnConfetti(in size: CGSize) {
        guard spawnedCount < maxPieces else { return }

        // spawn a small batch each frame
        let batchSize = 4

        for _ in 0..<batchSize {
            let piece = ConfettiPiece(
                x: CGFloat.random(in: 0...size.width),
                y: -10, // start just above screen
                size: CGFloat.random(in: 6...12),
                color: colors.randomElement()!,
                rotation: Double.random(in: 0...360),
                dx: CGFloat.random(in: -1.5...1.5),
                dy: CGFloat.random(in: 2...4)
            )

            pieces.append(piece)
            spawnedCount += 1
        }
    }
}

extension ConfettiView {
    func updateConfetti(in size: CGSize) {
        for i in pieces.indices {
            // movement
            pieces[i].x += pieces[i].dx
            pieces[i].y += pieces[i].dy

            // gravity (slight acceleration)
            pieces[i].dy += 0.05

            // horizontal air drift (wiggle)
            pieces[i].dx += CGFloat.random(in: -0.05...0.05)

            // clamp sideways speed so it doesn’t go crazy
            pieces[i].dx = pieces[i].dx.clamped(to: -2...2)

            // rotation
            pieces[i].rotation += Double(pieces[i].dx) * 2
        }

        // remove pieces that fall off screen
        pieces.removeAll { $0.y > size.height + 20 }
    }
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

//#Preview {
//   ConfettiView()
//}
