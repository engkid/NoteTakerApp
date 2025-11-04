import Foundation

public extension Date {
    func minutes(_ n: Int) -> Date { addingTimeInterval(TimeInterval(60 * n)) }
    var isPast: Bool { self < Date() }
}
