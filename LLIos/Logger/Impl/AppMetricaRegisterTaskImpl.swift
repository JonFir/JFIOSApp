import AppMetricaCore
import Logger

final class AppMetricaRegisterTaskImpl: AppMetricaRegisterTask {
    func register() {
        let configuration = AppMetricaConfiguration(
            apiKey: "your_key"
        )

        guard let configuration else { return }
        AppMetrica.activate(with: configuration)
    }
}
