import SwiftUI

public protocol TextStyle {
    associatedtype Body: View

    @ViewBuilder
    func apply(text: Text) -> Body
}

public extension Text {
    func textStyle<S: TextStyle>(_ style: S) -> some View {
        style.apply(text: self)
    }
}
