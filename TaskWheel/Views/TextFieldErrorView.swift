import SwiftUI

struct TextFieldErrorModifier: ViewModifier {
    @FocusState private var isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .autocorrectionDisabled()
            .onLongPressGesture(minimumDuration: 0.0) { self.isFocused = true }
    }
}

extension View {
    func preventTextFieldError() -> some View {
        self.modifier(TextFieldErrorModifier())
    }
}
