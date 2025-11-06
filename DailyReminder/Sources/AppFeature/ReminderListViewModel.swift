import Foundation
import Combine
import Domain
import Factory
import DI

@MainActor
final class ReminderListViewModel: ObservableObject {
  @Injected(\.saveReminder) private var saveReminder
  @Injected(\.deleteReminder) private var deleteReminder
  @Injected(\.reminderRepository) private var repo
  
  @Published var reminders: [Reminder] = []
  private var bag = Set<AnyCancellable>()
  
  init() {
    repo.changes
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$reminders)
  }
  
  func add(title: String, time: Date) async {
    let now = Date()
    var comps = Calendar.current.dateComponents([.year, .month, .day], from: now)
    let hm = Calendar.current.dateComponents([.hour, .minute], from: time)
    comps.hour = hm.hour
    comps.minute = hm.minute
    let start = Calendar.current.date(from: comps) ?? now
    
    let reminder = Reminder(title: title, startDate: start)
    try? await saveReminder(reminder)
  }
  
  func remove(_ id: UUID) async { try? await deleteReminder(id: id) }
}
