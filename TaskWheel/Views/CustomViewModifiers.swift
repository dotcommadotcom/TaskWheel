import SwiftUI

extension View {
    
    func xsmallFont() -> some View {
        self.modifier(FontSizeModifier(sizeOrder: .xsmall))
    }
    
    func smallFont() -> some View {
        self.modifier(FontSizeModifier(sizeOrder: .small))
    }
    
    func mediumFont() -> some View {
        self.modifier(FontSizeModifier(sizeOrder: .medium))
    }
    
    func largeFont() -> some View {
        self.modifier(FontSizeModifier(sizeOrder: .large))
    }
    
    func greyed() -> some View {
        self.modifier(GreyTextModifier())
    }
    
    func disableClick(if isDisabled: Bool) -> some View {
        self.modifier(DisableButtonModifier(isDisabled: isDisabled))
    }
    
    func noAnimation() -> some View {
        self.modifier(NoAnimationModifier())
    }
}

enum FontItem {
    case xsmall, small, large, medium
    
    var size: Font {
        switch self {
        case .xsmall: return Font.subheadline // 15
        case .small: return Font.title3 // 20
        case .medium: return Font.title2 // 22
        case .large: return Font.title // 28
        }
    }
}

struct FontSizeModifier: ViewModifier {
    
    let sizeOrder: FontItem

    func body(content: Content) -> some View {
        content
            .font(sizeOrder.size)
    }
}

struct GreyTextModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.text.opacity(0.5))
    }
}

struct DisableButtonModifier: ViewModifier {
    let isDisabled: Bool

    func body(content: Content) -> some View {
        content
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.5 : 1)
    }
}

struct NoAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .onTapGesture(perform: configuration.trigger)
    }
}

struct NoAnimationModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.buttonStyle(NoAnimationStyle())
    }
}
