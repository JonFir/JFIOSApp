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
                .target(name: Modules.firstModule, status: .required),
                .target(name: "\(Modules.firstModule)Impl", status: .required),
            ]
        ),
    ] 
        + module(name: Modules.firstModule)
)

enum Modules {
    static let firstModule = "FirstModule"
}
