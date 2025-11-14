import FactoryKit
import Logger
import UIKit

public class LoggerAutoRegister: AutoRegistering {

    public init() {}

    public func autoRegister() {
        #if QA
        let fileLoggerHandler = FileLoggerHandler()
        Container.shared.fileLogHandling.register { fileLoggerHandler }
        Container.shared.logger.register {
            return Logger(
                handlers: [
                    fileLoggerHandler
                ]
            )
        }
        #endif
        Container.shared.logger.register {
            #if DEBUG
            return Logger(
                handlers: [
                    OSLoggerHandler(subsystem: Bundle.main.bundleIdentifier ?? "", category: "app_logs")
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
