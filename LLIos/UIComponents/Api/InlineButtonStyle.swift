import SwiftUI
import Resources

public extension ButtonStyle where Self == InlineButtonStyle {
    @inlinable
    static var inline: InlineButtonStyle {
        InlineButtonStyle()
    }
}

public struct InlineButtonStyle: ButtonStyle {
    @Environment(\.isEnabled)
    private var isEnabled

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15))
            .foregroundColor(ResourcesAsset.textPrimary.swiftUIColor)
            .opacity(makeOpacity(configuration.isPressed))
    }

    private func makeOpacity(_ isPressed: Bool) -> Double {
        if !isEnabled {
            0.5
        } else if isPressed {
            0.7
        } else {
            1
        }
    }
}

public extension TextStyle where Self == InlineButtonTextStyle {
    @inlinable
    static var inlineButton: InlineButtonTextStyle {
        InlineButtonTextStyle()
    }
}

public struct InlineButtonTextStyle: TextStyle {

    public init() {}

    public func apply(text: Text) -> some View {
        text.font(.system(size: 15))
    }
}

#Preview {
    VStack(spacing: 15) {
        Button {
            print("Pressed")
        } label: {
            HStack {
                Text("START TRAINING").textStyle(.primaryButton)
                Image(systemName: "arrow.right")
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.inline)

        Button {
            print("Pressed")
        } label: {
            Label("Disabled", systemImage: "star")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.inline)
        .disabled(true)
    }.padding(20)
        .frame(maxHeight: .infinity, alignment: .top)
        .backgroundGradient()

}
