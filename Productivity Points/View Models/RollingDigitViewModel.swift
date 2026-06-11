//
//  RollingDigitViewModel.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 6/19/25.
//

//import SwiftUI
//
//struct RollingDigit: View {
//    var digit: Int
//    var font: Font = .system(size: 28, weight: .bold, design: .rounded)
//    var color: Color = .yellow
//
//    @State private var offset: CGFloat = 0
//
//    var body: some View {
//        VStack(spacing: 0) {
//            ForEach(0..<10) { num in
//                Text("\(num)")
//                    .font(font)
//                    .foregroundColor(color)
//                    .frame(height: 30)
//            }
//        }
//        .offset(y: CGFloat(-digit) * 30)
//        .frame(height: 30)
//        .clipped()
//        .onChange(of: digit) { _ in
//            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                offset = CGFloat(-digit) * 30
//            }
//        }
//    }
//}
//
//struct RollingNumber: View {
//    var number: Int
//
//    var body: some View {
//        HStack(spacing: 2) {
//            ForEach(number.digits, id: \.self) { digit in
//                RollingDigit(digit: digit)
//            }
//
//            Text(" pts")
//                .font(.system(size: 28, weight: .bold, design: .rounded))
//                .foregroundColor(.orange)
//        }
//    }
//}
//
//extension Int {
//    var digits: [Int] {
//        String(self).compactMap { $0.wholeNumberValue }
//    }
//}
