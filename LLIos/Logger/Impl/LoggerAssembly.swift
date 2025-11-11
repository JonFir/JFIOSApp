import Swinject
import Logger
import UIKit

public class LoggerAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(Logger.self) { r in
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
