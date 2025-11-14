// swift-tools-version: 6.2
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings
    import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
        productTypes: [
            "FactoryKit": Constants.remoteDependenciesType
        ],
        baseSettings: .settings(
            base: [
                "SWIFT_VERSION": "6.2",
            ],
            configurations: [
                .debug(name: .debug, settings: ["SWIFT_VERSION": "6.2"]),
                .release(name: Constants.qaConfigurationName, settings: ["SWIFT_VERSION": "6.2"]),
                .release(name: .release, settings: ["SWIFT_VERSION": "6.2"]),
            ]
        )
    )
#endif

let package = Package(
    name: "test",
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", .upToNextMajor(from: "2.4.12"))
    ]
)
