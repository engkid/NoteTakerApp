//
//  AddReminderSheet.swift
//  NoteTakerApp
//
//  Created by Engkit Riswara on 04/11/25.
//

import SwiftUI

struct AddReminderSheet: View {
  @Environment(\.dismiss) private var dismiss
  
  @State private var title: String = ""
  @State private var time: Date = Calendar.current.date(bySettingHour: 9, minute: 30, second: 0, of: .now) ?? .now
  @FocusState private var titleFocused: Bool
  
  let onSave: (_ title: String, _ time: Date) -> Void
  
  var body: some View {
    NavigationStack {
      Form {
        Section("Reminder") {
          TextField("Name (e.g., Standup)", text: $title)
            .focused($titleFocused)
            .submitLabel(.done)
        }
        Section("Time") {
          DatePicker("Starts at", selection: $time, displayedComponents: .hourAndMinute)
            .datePickerStyle(.wheel) // or .compact
        }
      }
      .navigationTitle("New Reminder")
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") {
            onSave(title.trimmingCharacters(in: .whitespacesAndNewlines), time)
            dismiss()
          }
          .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
      }
      .onAppear { titleFocused = true }
    }
  }
}
