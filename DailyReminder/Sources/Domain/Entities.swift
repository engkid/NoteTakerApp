import Foundation

public struct Reminder: Identifiable, Equatable, Sendable {
    public let id: UUID
    public var title: String
    public var notes: String?
    public var startDate: Date
    public var isAllDay: Bool
    public var isActive: Bool
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = .init(),
        title: String,
        notes: String? = nil,
        startDate: Date,
        isAllDay: Bool = false,
        isActive: Bool = true,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.startDate = startDate
        self.isAllDay = isAllDay
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
