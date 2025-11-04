import Foundation
import Factory
import SwiftData
import Domain
import Persistence
import Notifications
import Background

// MARK: - Dependency Graph
extension Container {
    // MARK: SwiftData
    public var modelContainer: Factory<ModelContainer> {
        self {
            let schema = Schema([ReminderModel.self])
            return try! ModelContainer(for: schema)
        }
        .singleton
    }

    public var modelContext: Factory<ModelContext> {
        self { ModelContext(self.modelContainer()) }
    }

    // MARK: Repository
    public var reminderRepository: Factory<ReminderRepository> {
        self { SwiftDataReminderRepository(context: self.modelContext()) }
        .singleton
    }

    // MARK: Notifications / Background
    public var notificationScheduler: Factory<NotificationScheduler> {
        self { LocalNotificationScheduler() }
        .singleton
    }

    public var backgroundScheduler: Factory<BackgroundScheduler> {
        self {
            ReminderBackgroundScheduler(
                repo: self.reminderRepository(),
                notifier: self.notificationScheduler()
            )
        }
        .singleton
    }

    // MARK: Use Cases
    public var saveReminder: Factory<CreateOrUpdateReminderUseCase> {
        self {
            CreateOrUpdateReminderUseCase(
                repo: self.reminderRepository(),
                notifier: self.notificationScheduler()
            )
        }
    }

    public var deleteReminder: Factory<DeleteReminderUseCase> {
        self {
            DeleteReminderUseCase(
                repo: self.reminderRepository(),
                notifier: self.notificationScheduler()
            )
        }
    }
}
