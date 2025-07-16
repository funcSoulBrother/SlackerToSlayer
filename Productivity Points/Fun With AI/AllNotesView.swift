//
//  AllNotesView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 5/3/25.
//

import SwiftUI

struct AllNotesView: View {
    @State private var notes: [(date: String, content: String)] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(notes, id: \.date) { note in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.date)
                            .font(.headline)
                        Text(note.content)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("All Notes")
        }
        .onAppear(perform: loadNotes)
    }

    private func loadNotes() {
        let allDefaults = UserDefaults.standard.dictionaryRepresentation()
        let notePrefix = "note_"

        let filtered = allDefaults
            .filter { $0.key.hasPrefix(notePrefix) && $0.value is String }

        let mapped = filtered.map { (key, value) in
            let dateString = String(key.dropFirst(notePrefix.count))
            return (date: dateString, content: value as! String)
        }

        // Sort by date ascending
        notes = mapped.sorted { $0.date < $1.date }
    }
}

#Preview {
    AllNotesView()
}
