// swift-tools-version: 6.2
import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
        productTypes: [
            "FactoryKit": Constants.remoteDependenciesType,
            "KeychainAccess": Constants.remoteDependenciesType,
        ],
        baseSettings: .settings(
            configurations: [
                .debug(name: .debug, settings: [
                    "CLANG_ENABLE_EXPLICIT_MODULES": false,
                ]),
                .release(name: Constants.qaConfigurationName, settings: [
                    "CLANG_ENABLE_EXPLICIT_MODULES": false,
                ]),
                .release(name: .release, settings: [
                    "CLANG_ENABLE_EXPLICIT_MODULES": false,
                ]),
            ]
        ),
        targetSettings: [
            "FactoryKit": makeFactoryKitSettings()
        ]
    )

func makeFactoryKitSettings() -> Settings {
    let swiftVersion = SettingValue(stringLiteral: "6.2")
    return Settings.settings(
        configurations: [
            .debug(name: .debug, settings: [
                "SWIFT_VERSION": swiftVersion,
            ]),
            .release(name: Constants.qaConfigurationName, settings: [
                "SWIFT_VERSION": swiftVersion,
            ]),
            .release(name: .release, settings: [
                "SWIFT_VERSION": swiftVersion,
            ]),
        ])
}
#endif

let package = Package(
    name: "test",
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", .upToNextMajor(from: "2.4.12")),
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", .upToNextMajor(from: "4.2.2")),
    ]
)


