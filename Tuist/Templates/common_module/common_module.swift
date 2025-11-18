import ProjectDescription
import ProjectDescriptionHelpers

let nameAttribute: Template.Attribute = .required("name")
let onlyApiAttribute: Template.Attribute = .optional("only_api", default: "false")

func makeItems() -> [Template.Item] {
    var items: [Template.Item] = [
        .string(
            path: "\(Constants.modulesFolder)/\(nameAttribute)/Api/Dummy.swift",
            contents: "//\n//  Dummy.swift"
        ),
        .string(
            path: "\(Constants.modulesFolder)/\(nameAttribute)/Tests/DummyTests.swift",
            contents: "//\n//  DummyTests.swift"
        ),
    ]
    
    if "\(onlyApiAttribute)" == "false" {
        items.append(contentsOf: [
            .string(
                path: "\(Constants.modulesFolder)/\(nameAttribute)/Impl/Dummy.swift",
                contents: "//\n//  Dummy.swift"
            ),
            .string(
                path: "\(Constants.modulesFolder)/\(nameAttribute)/Resources/.gitkeep",
                contents: ""
            ),
        ])
    }
    
    return items
}

let template = Template(
    description: "Common module",
    attributes: [
        nameAttribute,
        .optional("platform", default: "ios"),
        onlyApiAttribute,
    ],
    items: makeItems()
)
