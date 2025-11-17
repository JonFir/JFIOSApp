import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Constants.appName,
    settings: Settings.settings(
        base: [
            "SWIFT_VERSION": "6.2",
            "OTHER_LDFLAGS": "$(inherited) -ObjC",
            "CLANG_ENABLE_EXPLICIT_MODULES": false,
        ],
        configurations: [
            .debug(
                name: .debug,
                settings: [
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG"
                ]
            ),
            .release(
                name: Constants.qaConfigurationName,
                settings: [
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "QA",
                ]
            ),
            .release(
                name: .release,
                settings: [
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE"
                ]
            ),
        ]
    ),
    targets: [
        .target(
            name: Constants.appName,
            destinations: .iOS,
            product: .app,
            bundleId: Constants.bundleId,
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": true,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ],
                    ],
                    "UILaunchStoryboardName": "LaunchScreen",
                    "APP_METRICA_KEY": .string(Env.appMetricaKey),
                ]
            ),
            buildableFolders: [
                BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/App/Sources"),
                BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/App/Resources"),
            ],
            dependencies: [
                Modules.firstModule.apiTarget,
                Modules.logger.apiTarget,
                Modules.settings.apiTarget,
            ]
                + Modules.allCases.map(\.implTarget)
        ),
    ]
    + module(moduleInfo: Modules.firstModule, implDependencies: [Modules.logger.apiTarget])
    + module(moduleInfo: Modules.logger, implDependencies: [
        Dependencies.appMetricaCore.target,
        Dependencies.appMetricaCrashes.target,
        Modules.settings.apiTarget,
    ])
    + module(moduleInfo: Modules.settings),
    schemes: [
        Scheme.scheme(
            name: "QA",
            buildAction: BuildAction.buildAction(targets: [.target(Constants.appName)]),
            runAction: RunAction.runAction(configuration: Constants.qaConfigurationName)
        )
    ]
)

enum Modules: String, ModuleInfo, CaseIterable {
    case firstModule = "FirstModule"
    case logger = "Logger"
    case settings = "Settings"
}

enum Dependencies: String, CaseIterable {
    case factory = "FactoryKit"
    case appMetricaCore = "AppMetricaCore"
    case appMetricaCrashes = "AppMetricaCrashes"
}



extension Dependencies {
    var target: TargetDependency {
        .external(name: rawValue)
    }
}
