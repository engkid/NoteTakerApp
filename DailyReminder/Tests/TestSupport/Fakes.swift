import Foundation
import Combine
import Domain

public final class InMemoryReminderRepository: ReminderRepository {
    private var storage: [UUID: Reminder] = [:]
    private let subject = CurrentValueSubject<[Reminder], Never>([])
    public var changes: AnyPublisher<[Reminder], Never> { subject.eraseToAnyPublisher() }

    public init() {}

    public func upsert(_ r: Reminder) async throws {
        storage[r.id] = r
        subject.send(storage.values.sorted { $0.startDate < $1.startDate })
    }

    public func delete(id: UUID) async throws {
        storage.removeValue(forKey: id)
        subject.send(storage.values.sorted { $0.startDate < $1.startDate })
    }

    public func reminder(id: UUID) async throws -> Reminder? { storage[id] }

    public func upcoming(from: Date, limit: Int) async throws -> [Reminder] {
        storage.values.filter { $0.startDate >= from && $0.isActive }
            .sorted { $0.startDate < $1.startDate }
            .prefix(limit)
            .map { $0 }
    }
}

public final class StubNotificationScheduler: NotificationScheduler {
    public init() {}
    public private(set) var scheduled: [UUID] = []
    public func requestAuthorizationIfNeeded() async throws {}
    public func scheduleTenMinutePrealert(for reminder: Reminder) async throws { scheduled.append(reminder.id) }
    public func cancel(for reminderID: UUID) async { scheduled.removeAll { $0 == reminderID } }
}
