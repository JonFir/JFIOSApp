import SwiftUI
import LibSwiftUI

// MARK: - Title Style

public extension TextStyle where Self == TitleTextStyle {
    @inlinable
    static var title: TitleTextStyle {
        TitleTextStyle()
    }
}

public struct TitleTextStyle: TextStyle {
    public init() {}
    
    public func apply(text: Text) -> some View {
        text
            .font(.system(size: 28, weight: .black))
            .tracking(2)
    }
}

// MARK: - Subtitle Style

public extension TextStyle where Self == SubtitleTextStyle {
    @inlinable
    static var subtitle: SubtitleTextStyle {
        SubtitleTextStyle()
    }
}

public struct SubtitleTextStyle: TextStyle {
    public init() {}
    
    public func apply(text: Text) -> some View {
        text
            .font(.system(size: 14, weight: .medium))
            .tracking(1)
    }
}

// MARK: - Field Label Style

public extension TextStyle where Self == FieldLabelTextStyle {
    @inlinable
    static var fieldLabel: FieldLabelTextStyle {
        FieldLabelTextStyle()
    }
}

public struct FieldLabelTextStyle: TextStyle {
    public init() {}
    
    public func apply(text: Text) -> some View {
        text
            .font(.system(size: 12, weight: .semibold))
            .textCase(.uppercase)
            .tracking(1)
    }
}

// MARK: - Body Style

public extension TextStyle where Self == BodyTextStyle {
    @inlinable
    static var body: BodyTextStyle {
        BodyTextStyle()
    }
}

public struct BodyTextStyle: TextStyle {
    public init() {}
    
    public func apply(text: Text) -> some View {
        text.font(.system(size: 15))
    }
}

