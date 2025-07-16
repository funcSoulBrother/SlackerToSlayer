//
//  DailyNoteView2.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 5/3/25.
//

import SwiftUI

struct DailyNoteView2: View {
    @State private var note: String = ""
    @State private var yesterdayNote: String = ""

    // Formatter to turn a date into "yyyy-MM-dd"
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    // Key for today
    private var todayKey: String {
        "note_" + formatter.string(from: Date())
    }

    // Key for yesterday
    private var yesterdayKey: String {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        return "note_" + formatter.string(from: yesterday)
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Note for Today")
                .font(.title)

            TextEditor(text: $note)
                .border(Color.gray)
                .padding()

            Button("Save Note") {
                UserDefaults.standard.set(note, forKey: todayKey)
            }
            .buttonStyle(.borderedProminent)

            Divider()

            Text("Yesterday's Note")
                .font(.headline)
                .padding(.top)

            Text(yesterdayNote.isEmpty ? "No note for yesterday." : yesterdayNote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
        }
        .padding()
        .onAppear {
            note = UserDefaults.standard.string(forKey: todayKey) ?? ""
            yesterdayNote = UserDefaults.standard.string(forKey: yesterdayKey) ?? ""
        }
    }
}

#Preview {
    DailyNoteView2()
}
