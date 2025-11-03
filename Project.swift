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
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/App/Sources"),
                BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/App/Resources"),
            ],
            dependencies: []
        ),
    ] 
        + module(name: Modules.firstModule)
)

enum Modules {
    static let firstModule = "FirstModule"
}