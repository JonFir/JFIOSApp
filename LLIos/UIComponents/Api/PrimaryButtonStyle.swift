import SwiftUI
import Resources
import LibSwiftUI

public extension ButtonStyle where Self == PrimaryButtonStyle {
    @inlinable
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}

public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled)
    private var isEnabled

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .frame(height: 56)
            .padding(.horizontal, 16)
            .background(
                LinearGradient(
                    colors: [
                        ResourcesAsset.primaryRed.swiftUIColor,
                        ResourcesAsset.secondaryRed.swiftUIColor,
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
            .shadow(
                color: Color(red: 1.0, green: 0.2, blue: 0.2).opacity(0.4),
                radius: 15,
                y: 5
            )
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

public extension TextStyle where Self == PrimaryButtonTextStyle {
    @inlinable
    static var primaryButton: PrimaryButtonTextStyle {
        PrimaryButtonTextStyle()
    }
}

public struct PrimaryButtonTextStyle: TextStyle {

    public init() {}

    public func apply(text: Text) -> some View {
        text
            .font(.system(size: 16, weight: .bold))
            .tracking(1.5)
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
        }
        .buttonStyle(.primary)

        Button {
            print("Pressed")
        } label: {
            Label("Disabled", systemImage: "star")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.primary)
        .disabled(true)
    }.padding(20)
        .frame(maxHeight: .infinity, alignment: .top)
        .backgroundGradient()

}
