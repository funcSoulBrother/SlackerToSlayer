//
//  ColorButtonComponent.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 2/21/26.
//
import SwiftUI

import SwiftUI

struct ColorButton: View {
    let color: Color
    @Binding var selectedColor: Color

    var isSelected: Bool {
        color.toHex() == selectedColor.toHex()
    }

    var body: some View {
        Button {
            selectedColor = color
        } label: {
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
                .overlay {
                    if isSelected {
                        Circle()
                            .stroke(.white, lineWidth: 3)
                    }
                }
        }
        .buttonStyle(.plain)
    }
}
