import SwiftUI

public struct ReminderListScreen: View {
  @StateObject private var vm = ReminderListViewModel()
  @State private var showAddSheet = false
  
  public init() {}
  
  public var body: some View {
    NavigationStack {
      List(vm.reminders) { r in
        VStack(alignment: .leading, spacing: 4) {
          Text(r.title).font(.headline)
          Text(r.startDate.formatted(date: .abbreviated, time: .shortened))
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .swipeActions {
          Button(role: .destructive) {
            Task { await vm.remove(r.id) }
          } label: { Label("Delete", systemImage: "trash") }
        }
      }
      .navigationTitle("Reminders")
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button { showAddSheet = true } label: { Image(systemName: "plus") }
        }
      }
      .sheet(isPresented: $showAddSheet) {
        AddReminderSheet { title, time in
          Task { await vm.add(title: title, time: time) }
        }
        // nice bottoms sheet behavior (iOS 16/17+)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
      }
    }
  }
}
