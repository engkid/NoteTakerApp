import Foundation
import Combine

public protocol ReminderRepository {
    func upsert(_ reminder: Reminder) async throws
    func delete(id: UUID) async throws
    func reminder(id: UUID) async throws -> Reminder?
    func upcoming(from: Date, limit: Int) async throws -> [Reminder]
    var changes: AnyPublisher<[Reminder], Never> { get }
}

public protocol NotificationScheduler {
    func requestAuthorizationIfNeeded() async throws
    func scheduleTenMinutePrealert(for reminder: Reminder) async throws
    func cancel(for reminderID: UUID) async
}

public protocol BackgroundScheduler {
    func registerHandlers()
    func scheduleDailyMaintenance()
}
