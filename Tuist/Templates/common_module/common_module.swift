import ProjectDescription
import ProjectDescriptionHelpers

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Custom template",
    attributes: [
        nameAttribute,
        .optional("platform", default: "ios"),
    ],
    items: [
        .string(
            path: "\(Constants.modulesFolder)/\(nameAttribute)/Api/\(nameAttribute).swift",
            contents: ""
        ),
        .string(
            path: "\(Constants.modulesFolder)/\(nameAttribute)/Impl/\(nameAttribute).swift",
            contents: ""
        ),
        .string(
            path: "\(Constants.modulesFolder)/\(nameAttribute)/Resources/.gitkeep",
            contents: ""
        ),
        .string(
            path: "\(Constants.modulesFolder)/\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
            contents: ""
        ),
    ]
)
