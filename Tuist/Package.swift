// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings
    import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
        productTypes: [
            "Swinject": Constants.remoteDependenciesType
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
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.8.0"))
    ]
)
