import Foundation
@testable import PropertyList

final class LoggerFake: Logger {
    var logged: [String: PropertyList.LogLevel] = [:]
    
    func log(_ message: String, logLevel: PropertyList.LogLevel) {
        logged[message] = logLevel
    }
}
