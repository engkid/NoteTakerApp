import XCTest
import TestSupport
import Domain

final class UseCaseTests: XCTestCase {
    func testSaveSchedulesNotification() async throws {
        let repo = InMemoryReminderRepository()
        let notif = StubNotificationScheduler()
        let uc = CreateOrUpdateReminderUseCase(repo: repo, notifier: notif)

        let r = Reminder(title: "Demo", startDate: .now.addingTimeInterval(3600))
        try await uc(r)
        XCTAssertTrue(notif.scheduled.contains(r.id))
    }
}
