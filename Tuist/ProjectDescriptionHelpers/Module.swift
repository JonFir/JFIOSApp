import ProjectDescription

public func module(name: String, dependencies: [TargetDependency] = []) -> [Target] {
    [
        .target(
            name: name,
            destinations: .iOS,
            product: Constants.moduleType,
            bundleId: "\(Constants.bundleId).\(name)Api",
            infoPlist: .default,
            buildableFolders: [
                BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/\(name)/Api"),
            ],
            dependencies: dependencies
        ),
        .target(
            name: "\(name)Impl",
            destinations: .iOS,
            product: Constants.moduleType,
            bundleId: "\(Constants.bundleId).\(name)Impl",
            infoPlist: .default,
            buildableFolders: [
                BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/\(name)/Impl"),
                BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/\(name)/Resources"),
            ],
            dependencies: dependencies + [.target(name: name)]
        ),
        .target(
            name: "\(name)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Constants.bundleId).\(name)Tests",
            infoPlist: .default,
            buildableFolders: [
                BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/\(name)/Tests"),
            ],
            dependencies: [.target(name: "\(name)Impl")]
        )
    ]
}
