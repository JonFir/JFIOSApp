import SwiftUI
import Resources

public struct DefaultTextField: View {
    private let title: String
    private let isSecure: Bool
    private let text: Binding<String>
    private let corenerRadius = 12.0
    @Environment(\.isEnabled)
    private var isEnabled

    public init (
        title: String,
        isSecure: Bool = false,
        text: Binding<String>
    ) {
        self.title = title
        self.isSecure = isSecure
        self.text = text
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(ResourcesAsset.textPrimary.swiftUIColor.opacity(0.8))
                .textCase(.uppercase)
                .tracking(1)

            UniversaltextField(isSecure: isSecure, text: text)
                .foregroundColor(ResourcesAsset.textPrimary.swiftUIColor)
                .accentColor(ResourcesAsset.primaryRed.swiftUIColor)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: corenerRadius)
                        .fill(ResourcesAsset.textPrimary.swiftUIColor.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: corenerRadius)
                        .stroke(ResourcesAsset.textPrimary.swiftUIColor.opacity(0.2), lineWidth: 1)
                )
        }
        .opacity(isEnabled ? 1 : 0.5)
    }
}

private struct UniversaltextField: View {
    let isSecure: Bool
    @Binding var text: String

    var body: some View {
        if isSecure {
            SecureField("", text: $text)
        } else {
            TextField("", text: $text)
        }
    }
}

#Preview {
    VStack(spacing: 15) {
        DefaultTextField(
            title: "Filled",
            text: .constant("example.com")
        )
        DefaultTextField(
            title: "Disabled",
            text: .constant("ssd")
        ).disabled(true)
        DefaultTextField(
            title: "Empty",
            text: .constant("")
        )
        DefaultTextField(
            title: "Secured",
            isSecure: true,
            text: .constant("password")
        )
        DefaultTextField(
            title: "Secured empty",
            isSecure: true,
            text: .constant("")
        )
    }.padding(20)
        .frame(maxHeight: .infinity, alignment: .top)
        .backgroundGradient()
}
