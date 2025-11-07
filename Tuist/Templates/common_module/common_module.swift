import ProjectDescription
import ProjectDescriptionHelpers

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Common module",
    attributes: [
        nameAttribute,
        .optional("platform", default: "ios"),
    ],
    items: [
        .string(
            path: "\(Constants.modulesFolder)/\(nameAttribute)/Api/Dummy.swift",
            contents: "//\n//  Dummy.swift"
        ),
        .string(
            path: "\(Constants.modulesFolder)/\(nameAttribute)/Impl/Dummy.swift",
            contents: "//\n//  Dummy.swift"
        ),
        .string(
            path: "\(Constants.modulesFolder)/\(nameAttribute)/Resources/.gitkeep",
            contents: ""
        ),
        .string(
            path: "\(Constants.modulesFolder)/\(nameAttribute)/Tests/DummyTests.swift",
            contents: "//\n//  DummyTests.swift"
        ),
    ]
)
