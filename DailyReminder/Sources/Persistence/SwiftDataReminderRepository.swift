import Foundation
import SwiftData
import Combine
import Domain

public final class SwiftDataReminderRepository: ReminderRepository {
    private let context: ModelContext
    private let subject = CurrentValueSubject<[Reminder], Never>([])

    public var changes: AnyPublisher<[Reminder], Never> { subject.eraseToAnyPublisher() }

    public init(context: ModelContext) { self.context = context ; Task { await refreshStream() } }

    @MainActor private func refreshStream() async {
        do {
            let fetch = FetchDescriptor<ReminderModel>(sortBy: [SortDescriptor(\.startDate)])
            let models = try context.fetch(fetch)
            subject.send(models.map(Reminder.init))
        } catch { subject.send([]) }
    }

  public func upsert(_ r: Reminder) async throws {
      try await MainActor.run {
          let rid = r.id                         // <-- capture as a plain value
          let descriptor = FetchDescriptor<ReminderModel>(
              predicate: #Predicate { $0.id == rid }
          )

          let existing = try? context.fetch(descriptor).first
          let model = existing ?? ReminderModel(r)

          if existing != nil {
              model.title     = r.title
              model.notes     = r.notes
              model.startDate = r.startDate
              model.isAllDay  = r.isAllDay
              model.isActive  = r.isActive
              model.updatedAt = .now
          } else {
              context.insert(model)
          }

          try context.save()
      }
      await refreshStream()
  }

    public func delete(id: UUID) async throws {
        try await MainActor.run {
            let descriptor = FetchDescriptor<ReminderModel>(predicate: #Predicate { $0.id == id })
            if let model = try context.fetch(descriptor).first { context.delete(model); try context.save() }
        }
        await refreshStream()
    }

    public func reminder(id: UUID) async throws -> Reminder? {
        try await MainActor.run {
            let descriptor = FetchDescriptor<ReminderModel>(predicate: #Predicate { $0.id == id })
            return try context.fetch(descriptor).first.map(Reminder.init)
        }
    }

    public func upcoming(from: Date, limit: Int) async throws -> [Reminder] {
        try await MainActor.run {
            var desc = FetchDescriptor<ReminderModel>(
                predicate: #Predicate { $0.startDate >= from && $0.isActive == true },
                sortBy: [SortDescriptor(\.startDate, order: .forward)]
            )
            desc.fetchLimit = limit
            return try context.fetch(desc).map(Reminder.init)
        }
    }
}
