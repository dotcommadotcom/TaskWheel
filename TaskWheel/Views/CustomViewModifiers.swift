import SwiftUI

extension View {
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
