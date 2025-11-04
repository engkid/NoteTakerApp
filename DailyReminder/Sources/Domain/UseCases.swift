import Foundation

public struct CreateOrUpdateReminderUseCase {
    let repo: ReminderRepository
    let notifier: NotificationScheduler

    public init(repo: ReminderRepository, notifier: NotificationScheduler) {
        self.repo = repo
        self.notifier = notifier
    }

    public func callAsFunction(_ reminder: Reminder) async throws {
        try await repo.upsert(reminder)
        try await notifier.scheduleTenMinutePrealert(for: reminder)
    }
}

public struct DeleteReminderUseCase {
    let repo: ReminderRepository
    let notifier: NotificationScheduler

    public init(repo: ReminderRepository, notifier: NotificationScheduler) {
        self.repo = repo
        self.notifier = notifier
    }

    public func callAsFunction(id: UUID) async throws {
        try await repo.delete(id: id)
        await notifier.cancel(for: id)
    }
}
