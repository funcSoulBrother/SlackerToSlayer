//
//  ConfettiModel.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 3/24/26.
//

import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var color: Color
    var rotation: Double
    var dx: CGFloat 
    var dy: CGFloat
}
