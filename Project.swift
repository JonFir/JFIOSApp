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
    ]
        + Modules.impls.map(\.implTarget)
)

let resoursesTarget = Target.target(
    name: Modules.resources.apiName,
    destinations: .iOS,
    product: Constants.moduleType,
    bundleId: "\(Constants.bundleId).\(Modules.resources.apiName)",
    infoPlist: .default,
    resources: [
        "\(Constants.modulesFolder)/\(Modules.resources.rawValue)/**"
    ],
    settings: .settings()
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
        resoursesTarget,
    ]
    + module(moduleInfo: Modules.firstModule, implDependencies: [Modules.logger.apiTarget])
    + module(moduleInfo: Modules.logger, implDependencies: [
        Dependencies.appMetricaCore.target,
        Dependencies.appMetricaCrashes.target,
        Modules.settings.apiTarget,
    ])
    + module(moduleInfo: Modules.settings, apiDependencies: [Modules.libSwift.apiTarget])
    + module(
        moduleInfo: Modules.libSwift,
        onlyApi: true,
        apiDependencies: [Dependencies.keychainAccess.target]
    )
    + module(moduleInfo: Modules.libUIKit, onlyApi: true)
    + module(
        moduleInfo: Modules.libNetwork,
        apiDependencies: [
            Modules.libSwift.apiTarget,
        ],
        implDependencies: [
            Modules.libSwift.apiTarget,
            Modules.accountStorage.apiTarget,
            Modules.logger.apiTarget,
            Modules.settings.apiTarget,
            Dependencies.alamofire.target,
        ]
    )
    + module(moduleInfo: Modules.navigator, implDependencies: [
        Modules.libSwift.apiTarget,
        Modules.uiSplash.apiTarget,
        Modules.logger.apiTarget,
    ])
    + module(
        moduleInfo: Modules.uiSplash,
        apiDependencies: [
            Modules.libUIKit.apiTarget,
        ],
        implDependencies: [
            Modules.libSwift.apiTarget,
            Modules.libUIKit.apiTarget,
            Modules.navigator.apiTarget,
            Modules.logger.apiTarget,
            Modules.uiComponents.apiTarget,
        ]
    )
    + module(
        moduleInfo: Modules.accountStorage,
        apiDependencies: [
            Modules.libSwift.apiTarget
        ],
        implDependencies: [
            Modules.logger.apiTarget,
            Modules.settings.apiTarget,
            Modules.libSwift.apiTarget,
        ]
    )
    + module(moduleInfo: Modules.uiLogin, implDependencies: [
        Modules.libSwift.apiTarget,
        Modules.libUIKit.apiTarget,
        Modules.uiComponents.apiTarget,
        Modules.resources.apiTarget,
        Modules.navigator.apiTarget,
        Modules.logger.apiTarget,
    ])
    + module(moduleInfo: Modules.uiRegistration, implDependencies: [
        Modules.libSwift.apiTarget,
        Modules.libUIKit.apiTarget,
    ])
    + module(moduleInfo: Modules.uiComponents, onlyApi: true, apiDependencies: [
        Modules.resources.apiTarget,
    ]),
    schemes: schemes,
    resourceSynthesizers: [
        .assets(),
        .files(extensions: ["xcstrings"]),
    ]
)

enum Modules: String, ModuleInfo {
    case resources = "Resources"
    case firstModule = "FirstModule"
    case logger = "Logger"
    case settings = "Settings"
    case libSwift = "LibSwift"
    case libUIKit = "LibUIKit"
    case libNetwork = "LibNetwork"
    case navigator = "Navigator"
    case uiSplash = "UISplash"
    case accountStorage = "AccountStorage"
    case uiLogin = "UILogin"
    case uiRegistration = "UIRegistration"
    case uiComponents = "UIComponents"

    static var impls: [Modules] {
        [
            .firstModule,
            .logger,
            .settings,
            .libNetwork,
            .navigator,
            .uiSplash,
            .accountStorage,
            .uiLogin,
            .uiRegistration,
        ]
    }
}

enum Dependencies: String, CaseIterable {
    case factory = "FactoryKit"
    case factoryTesting = "FactoryTesting"
    case appMetricaCore = "AppMetricaCore"
    case appMetricaCrashes = "AppMetricaCrashes"
    case keychainAccess = "KeychainAccess"
    case alamofire = "Alamofire"
}

extension Dependencies {
    var target: TargetDependency {
        .external(name: rawValue)
    }
}
