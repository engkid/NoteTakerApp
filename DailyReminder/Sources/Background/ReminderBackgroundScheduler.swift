import Foundation
import BackgroundTasks
import Domain

public final class ReminderBackgroundScheduler: BackgroundScheduler {
    private let repo: ReminderRepository
    private let notifier: NotificationScheduler
    private let taskIdentifier = "com.example.dailyreminder.maintenance"

    public init(repo: ReminderRepository, notifier: NotificationScheduler) {
        self.repo = repo
        self.notifier = notifier
    }

    public func registerHandlers() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: nil) { [weak self] task in
            Task { await self?.handleMaintenance(task: task as? BGAppRefreshTask) }
        }
    }

    public func scheduleDailyMaintenance() {
        let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
        request.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 12, to: Date())
        do { try BGTaskScheduler.shared.submit(request) } catch { /* log */ }
    }

    private func handleMaintenance(task: BGAppRefreshTask?) async {
        task?.expirationHandler = { /* cancel if needed */ }
        do {
            let upcoming = try await repo.upcoming(from: .now, limit: 200)
            for r in upcoming { try? await notifier.scheduleTenMinutePrealert(for: r) }
            task?.setTaskCompleted(success: true)
        } catch { task?.setTaskCompleted(success: false) }
        scheduleDailyMaintenance()
    }
}
