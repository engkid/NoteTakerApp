import Foundation

public protocol ClockProtocol {
    func now() -> Date
}

public struct SystemClock: ClockProtocol { public init() {} ; public func now() -> Date { Date() } }
