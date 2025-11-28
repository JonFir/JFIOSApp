import SwiftUI
import Resources

public struct BackgroundGradient: ShapeStyle, View, Sendable {

    public init() {}

    public var body: some View {
        LinearGradient(
            colors: [
                ResourcesAsset.backgroundDarkTop.swiftUIColor,
                ResourcesAsset.backgroundDark.swiftUIColor,
                ResourcesAsset.backgroundDarkBottom.swiftUIColor,
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

public extension View {
    @inlinable
    func backgroundGradient() -> some View {
        background {
            BackgroundGradient().ignoresSafeArea()
        }
    }
}
