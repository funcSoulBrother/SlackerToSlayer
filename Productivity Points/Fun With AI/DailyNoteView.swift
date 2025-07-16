//
//  DailyNoteView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 5/3/25.
//


import SwiftUI

struct DailyNoteView: View {
    @State private var note: String = ""
    
    // Key is based on today's date in "yyyy-MM-dd" format
    private var todayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "note_" + formatter.string(from: Date())
    }

    var body: some View {
        NavigationView{
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
                NavigationLink("View All Notes") {
                    AllNotesView()
                }
            }
        }
        .padding()
        .onAppear {
            note = UserDefaults.standard.string(forKey: todayKey) ?? ""
        }
    }
}

#Preview {
    DailyNoteView()
}
