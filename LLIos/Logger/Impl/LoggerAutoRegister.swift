import FactoryKit
import Logger
import UIKit

public class LoggerAutoRegister: AutoRegistering {

    public init() {}

    public func autoRegister() {
        Container.shared.logger.register {
            #if DEBUG
            return Logger(
                handlers: [
                    OSLoggerHandler(subsystem: Bundle.main.bundleIdentifier ?? "", category: "app_logs")
                ]
            )
            #elseif QA
            return Logger(
                handlers: [
                    FileLoggerHandler()
                ]
            )
            #else
            return Logger(
                handlers: [
                    ServerLoggerHandler()
                ]
            )
            #endif
        }
    }
}
