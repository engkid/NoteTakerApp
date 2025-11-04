import Foundation
import SwiftData
import Domain

@Model
public final class ReminderModel {
    @Attribute(.unique) public  var id: UUID
    public var title: String
    public var notes: String?
    public var startDate: Date
    public var isAllDay: Bool
    public var isActive: Bool
    public var createdAt: Date
    public var updatedAt: Date

    public init(_ r: Reminder) {
        self.id = r.id
        self.title = r.title
        self.notes = r.notes
        self.startDate = r.startDate
        self.isAllDay = r.isAllDay
        self.isActive = r.isActive
        self.createdAt = r.createdAt
        self.updatedAt = r.updatedAt
    }
}

extension Domain.Reminder {
    init(_ m: ReminderModel) {
        self.init(
            id: m.id,
            title: m.title,
            notes: m.notes,
            startDate: m.startDate,
            isAllDay: m.isAllDay,
            isActive: m.isActive,
            createdAt: m.createdAt,
            updatedAt: m.updatedAt
        )
    }
}
