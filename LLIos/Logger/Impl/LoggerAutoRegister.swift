import FactoryKit
import Logger
import UIKit

public class LoggerAutoRegister: AutoRegistering {

    public init() {}

    public func autoRegister() {
        Container.shared.logger.register {
            let logger = Logger()
            #if DEBUG
            logger.handlers = [
                OSLoggerHandler(subsystem: Bundle.main.bundleIdentifier ?? "", category: "app_logs")
            ]
            #elseif QA
            logger.handlers = [
                FileLoggerHandler()
            ]
            #elseif RELEASE
            logger.handlers = [
                ServerLoggerHandler()
            ]
            #endif
            return logger
        }
    }
}
