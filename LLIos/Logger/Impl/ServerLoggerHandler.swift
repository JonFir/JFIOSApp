import Logger

final class ServerLoggerHandler: LoggerHandler {
    func log(
        level: LogLevel,
        message: String,
        parameters: [String : Any],
        category: LogCategory,
        module: String,
        file: String,
        line: Int,
        function: String
    ) {

    }
}
