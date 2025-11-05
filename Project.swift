import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Constants.appName,
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
                ]
            ),
            buildableFolders: [
                BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/App/Sources"),
                BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/App/Resources"),
            ],
            dependencies: [
                Modules.factory.implTarget,
                Modules.firstModule.apiTarget,
            ]
        ),
    ]
    + module(
        moduleInfo: Modules.factory,
        implDependencies: [
            Dependencies.Swinject.target,
        ] + Implementation.targets
    )
    + module(moduleInfo: Modules.firstModule, implDependencies: [Dependencies.Swinject.target])
    + module(moduleInfo: Modules.logger, implDependencies: [Dependencies.Swinject.target])
)

enum Implementation {
    static let targets = [
        Modules.firstModule.implTarget,
        Modules.logger.implTarget,
    ]
}

enum Modules: String, ModuleInfo {
    case firstModule = "FirstModule"
    case factory = "Factory"
    case logger = "Logger"
}

enum Dependencies: String {
    case Swinject = "Swinject"
}



extension Dependencies {
    var target: TargetDependency {
        .external(name: rawValue)
    }
}
