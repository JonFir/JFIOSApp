import Logger

final class FileLoggerHandler: LoggerHandler {
    func log(
        level: LogLevel,
        message: String,
        parameters: [String: Sendable],
        category: LogCategory,
        module: String,
        file: String,
        line: Int,
        function: String,
    ) {
        let formattedMessage = formatLogMessage(
            level: level,
            message: message,
            parameters: parameters,
            category: category,
            module: module,
            file: file,
            line: line,
            function: function
        )
    }
}
