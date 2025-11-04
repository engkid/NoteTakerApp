import Foundation
import UserNotifications
import Domain

public final class LocalNotificationScheduler: NotificationScheduler {
    public init() {}

    public func requestAuthorizationIfNeeded() async throws {
        let center = UNUserNotificationCenter.current()
        let status = await center.notificationSettings().authorizationStatus
        if status == .notDetermined {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if !granted { throw NSError(domain: "NotificationDenied", code: 1) }
        }
    }

    public func scheduleTenMinutePrealert(for reminder: Reminder) async throws {
        await cancel(for: reminder.id)
        guard reminder.isActive else { return }
        let fireDate = reminder.startDate.addingTimeInterval(-600)
        guard fireDate > Date() else { return }
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = "Starts in 10 minutes."
        content.sound = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(identifier: notifID(for: reminder.id), content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
    }

    public func cancel(for reminderID: UUID) async {
        await UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notifID(for: reminderID)])
    }

    private func notifID(for id: UUID) -> String { "reminder_\(id.uuidString)" }
}
