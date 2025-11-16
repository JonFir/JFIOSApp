import Logger
import AppMetricaCore
import AppMetricaCrashes

final class ServerLoggerHandler: LoggerHandler {
    func log(
        level: LogLevel,
        message: String,
        parameters: [String: Sendable],
        category: LogCategory,
        module: String,
        file: String,
        line: Int,
        function: String
    ) {
        guard level != .debug else { return }

        AppMetrica.reportEvent(name: message, parameters: parameters)

        if level == .critical {
            let error = AppMetricaError(
                identifier: message,
                message: message,
                parameters: parameters
            )
            AppMetricaCrashes.crashes().report(error: error)
        }

    }


}
