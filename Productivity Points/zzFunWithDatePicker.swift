//
//  zzFunWithDatePicker.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 5/3/25.
//

import SwiftUI

struct zzFunWithDatePicker: View {
    
    @State var selectedDate: Date = Date()
    let startingDate: Date = Calendar.current.date(from: DateComponents(year: 2025)) ?? Date()
    let endingDate: Date = Date()
   
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        VStack {
            Text("Selected date is:")
                .font(.custom("PressStart2P-Regular", size: 18))
                .padding()
            Text(dateFormatter.string(from: selectedDate))
                .font(.custom("PressStart2P-Regular", size: 16))
            DatePicker("Pick a Date!", selection: $selectedDate, in: startingDate...endingDate, displayedComponents: .date)
                .font(.custom("PressStart2P-Regular", size: 20))
                .foregroundStyle(.yellow)
                .padding()
        }
    }
}

struct zzFunWithDatePicker2: View {
    @State private var date = Date()
    @State private var showPicker = false
    
    var body: some View {
        VStack {
            Button("Pick a Date") {
                showPicker.toggle()
            }
            
            if showPicker {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .onChange(of: date) { _ in
                        // Hide picker after selection
                        showPicker = false
                    }
            }
            
            Text("Selected: \(date.formatted(date: .abbreviated, time: .omitted))")
        }
    }
}

#Preview {
    zzFunWithDatePicker()
    zzFunWithDatePicker2()
}
