import FactoryKit
import Logger
import UIKit

public class LoggerAutoRegister: AutoRegistering {

    public init() {}

    public func autoRegister() {
        var handlers: [LoggerHandler] = [
            ServerLoggerHandler(),
        ]
        Container.shared.appMetricaRegisterTask.register { AppMetricaRegisterTask() }
        #if DEBUG
        let handler = OSLoggerHandler(subsystem: Bundle.main.bundleIdentifier ?? "", category: "app_logs")
        handlers.append(handler)
        #elseif QA
        if let fileLoggerHandler = FileLoggerHandler() {
            handlers.append(fileLoggerHandler)
            Container.shared.fileLogHandling.register { fileLoggerHandler }
        }
        #endif
        Container.shared.logger.register { [handlers] in
            return Logger(
                handlers: handlers
            )
        }
    }
}
