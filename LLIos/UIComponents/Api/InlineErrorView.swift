import SwiftUI
import Resources

public struct InlineErrorView: View {
    private let message: String
    private let description: String?

    public init(message: String, description: String? = nil) {
        self.message = message
        self.description = description
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Image(systemName: "exclamationmark.triangle.fill")
                Text(message)
                    .lineLimit(1)
                    .textCase(.uppercase)
                    .font(.system(size: 12, weight: .medium))

            }
            .foregroundColor(ResourcesAsset.errorRed.swiftUIColor)
            if let description {
                Text(description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ResourcesAsset.errorRed.swiftUIColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack(spacing: 15) {
        InlineErrorView(
            message: "Не верный логин или пароль"
        )
        Divider().background(ResourcesAsset.textSecondary.swiftUIColor)
        InlineErrorView(
            message: "Не верный логин или пароль, Не верный логин или пароль"
        )
        Divider().background(ResourcesAsset.textSecondary.swiftUIColor)
        InlineErrorView(
            message: "Не верный логин или пароль",
            description: "Введите верные данные"
        )
        Divider().background(ResourcesAsset.textSecondary.swiftUIColor)
        InlineErrorView(
            message: "Не верный логин или пароль",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        )
        Divider().background(ResourcesAsset.textSecondary.swiftUIColor)
    }.padding(20)
        .frame(maxHeight: .infinity, alignment: .top)
        .backgroundGradient()

}
