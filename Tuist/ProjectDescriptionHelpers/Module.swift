import ProjectDescription

public func module<Info: ModuleInfo>(
    moduleInfo: Info,
    apiDependencies: [TargetDependency] = [],
    implDependencies: [TargetDependency] = [],
    testDependencies: [TargetDependency] = [],
) -> [Target] {
    [
        .target(
            name: moduleInfo.apiName,
            destinations: .iOS,
            product: Constants.moduleType,
            bundleId: "\(Constants.bundleId).\(moduleInfo.rawValue)Api",
            infoPlist: .default,
            buildableFolders: [
                BuildableFolder(stringLiteral: "\(Constants.modulesFolder)/\(moduleInfo.rawValue)/Api"),
            ],
            dependencies: apiDependencies + [.external(name: "FactoryKit")]
        ),
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
            dependencies: implDependencies + [moduleInfo.apiTarget, .external(name: "FactoryKit")]
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
            dependencies: testDependencies + [
                moduleInfo.apiTarget,
                moduleInfo.implTarget,
            ]
        )
    ]
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
