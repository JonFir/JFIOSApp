import ProjectDescription

public func module<Info: ModuleInfo>(
    moduleInfo: Info,
    onlyApi: Bool = false,
    apiDependencies: [TargetDependency] = [],
    implDependencies: [TargetDependency] = [],
    testDependencies: [TargetDependency] = [],
) -> [Target] {
    var targets: [Target] = [
        .target(
            name: moduleInfo.apiName,
            destinations: .iOS,
            product: Constants.moduleType,
            bundleId: "\(Constants.bundleId).\(moduleInfo.rawValue)Api",
            infoPlist: .default,
            buildableFolders: [
                BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/\(moduleInfo.rawValue)/Api"),
            ],
            dependencies: apiDependencies + [.external(name: "FactoryKit")],
            settings: .settings()
        ),
        .target(
            name: moduleInfo.testName,
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Constants.bundleId).\(moduleInfo.testName)",
            infoPlist: .default,
            buildableFolders: [
                BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/\(moduleInfo.rawValue)/Tests"),
            ],
            dependencies: testDependencies + baseTestDependencies(moduleInfo, onlyApi) + [.external(name: "FactoryTesting")],
            settings: .settings()
        )
    ]

    if !onlyApi {
        targets.append(
            .target(
                name: moduleInfo.implName,
                destinations: .iOS,
                product: Constants.moduleType,
                bundleId: "\(Constants.bundleId).\(moduleInfo.implName)",
                infoPlist: .default,
                buildableFolders: [
                    BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/\(moduleInfo.rawValue)/Impl"),
                    BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/\(moduleInfo.rawValue)/Resources"),
                ],
                dependencies: implDependencies + [moduleInfo.apiTarget, .external(name: "FactoryKit")],
                settings: .settings()
            ),
        )
    }
    return targets
}

private func baseTestDependencies<Info: ModuleInfo>(
    _ moduleInfo: Info,
    _ onlyApi: Bool = false,
) -> [TargetDependency] {
    if onlyApi {
        [moduleInfo.apiTarget]
    } else {
        [
            moduleInfo.apiTarget,
            moduleInfo.implTarget,
        ]
    }
}

public protocol ModuleInfo: RawRepresentable<String> {
    var apiName: String { get }
    var implName: String { get }
    var testName: String { get }
    var apiTarget: TargetDependency { get }
    var implTarget: TargetDependency { get }
    var testTarget: TargetDependency { get }
}

public extension ModuleInfo {
    var apiName: String {
        rawValue
    }

    var implName: String {
        "\(rawValue)Impl"
    }

    var testName: String {
        "\(rawValue)Tests"
    }

    var apiTarget: TargetDependency {
        .target(name: apiName)
    }

    var implTarget: TargetDependency {
        .target(name: implName)
    }

    var testTarget: TargetDependency {
        .target(name: testName)
    }

}
