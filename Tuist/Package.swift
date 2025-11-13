// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings
    import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
        productTypes: [
            "FactoryKit": Constants.remoteDependenciesType
        ],
        baseSettings: .settings(configurations: [
            .debug(name: .debug),
            .release(name: Constants.qaConfigurationName),
            .release(name: .release),
        ])
    )
#endif

let package = Package(
    name: "test",
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", .upToNextMajor(from: "2.4.12"))
    ]
)
