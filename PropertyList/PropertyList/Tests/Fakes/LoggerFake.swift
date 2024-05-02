import Foundation
@testable import PropertyList

final class LoggerFake: Logging {
    var logged: [String: PropertyList.LogLevel] = [:]
    
    func log(_ message: String, logLevel: PropertyList.LogLevel) {
        logged[message] = logLevel
    }
}
