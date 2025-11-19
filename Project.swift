import ProjectDescription
import ProjectDescriptionHelpers

let settings: Settings = Settings.settings(
    base: [
        "SWIFT_VERSION": "6.2",
        "OTHER_LDFLAGS": "$(inherited) -ObjC",
        "CLANG_ENABLE_EXPLICIT_MODULES": false,
        "SWIFT_APPROACHABLE_CONCURRENCY": true,
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
)

let appTarget: Target = Target.target(
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
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                        ],
                    ],
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
    scripts: [
        TargetScript.pre(
            script: """
                export PATH="/opt/homebrew/bin:$PATH"
                if command -v swiftlint >/dev/null 2>&1
                then
                    swiftlint
                else
                    echo "warning: `swiftlint` command not found - See https://github.com/realm/SwiftLint#installation for installation instructions."
                fi
                """,
            name: "SwiftLintScript"
        ),
    ],
    dependencies: [
        Modules.firstModule.apiTarget,
        Modules.logger.apiTarget,
        Modules.settings.apiTarget,
        Modules.navigator.apiTarget,
        Modules.libUIKit.apiTarget,
    ]
        + Modules.impls.map(\.implTarget)
)

let schemes: [Scheme] = [
    Scheme.scheme(
        name: "QA",
        buildAction: BuildAction.buildAction(targets: [.target(Constants.appName)]),
        runAction: RunAction.runAction(configuration: Constants.qaConfigurationName)
    ),
]

let project = Project(
    name: Constants.appName,
    settings: settings,
    targets: [
        appTarget,
    ]
    + module(moduleInfo: Modules.firstModule, implDependencies: [Modules.logger.apiTarget])
    + module(moduleInfo: Modules.logger, implDependencies: [
        Dependencies.appMetricaCore.target,
        Dependencies.appMetricaCrashes.target,
        Modules.settings.apiTarget,
    ])
    + module(moduleInfo: Modules.settings, apiDependencies: [Modules.libSwift.apiTarget])
    + module(moduleInfo: Modules.libSwift, onlyApi: true)
    + module(moduleInfo: Modules.libUIKit, onlyApi: true)
    + module(moduleInfo: Modules.navigator, implDependencies: [
        Modules.uiSplash.apiTarget,
        Modules.libUIKit.apiTarget,
    ])
    + module(moduleInfo: Modules.uiSplash, implDependencies: [
        Modules.libUIKit.apiTarget,
    ]),
    schemes: schemes
)

enum Modules: String, ModuleInfo {
    case firstModule = "FirstModule"
    case logger = "Logger"
    case settings = "Settings"
    case libSwift = "LibSwift"
    case libUIKit = "LibUIKit"
    case navigator = "Navigator"
    case uiSplash = "UISplash"

    static var impls: [Modules] {
        [
            .firstModule,
            .logger,
            .settings,
            .navigator,
            .uiSplash,
        ]
    }
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
