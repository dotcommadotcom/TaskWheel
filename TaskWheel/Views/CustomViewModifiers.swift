import SwiftUI

extension View {
    
    func xsmallFont() -> some View {
        self.modifier(SizeModifier(size: .xsmall))
    }
    
    func smallFont() -> some View {
        self.modifier(SizeModifier(size: .small))
    }
    
    func mediumFont() -> some View {
        self.modifier(SizeModifier(size: .medium))
    }
    
    func largeFont() -> some View {
        self.modifier(SizeModifier(size: .large))
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
    
    func alignIcon() -> some View {
        self.modifier(CheckmarkAlignmentModifier())
    }
    
    func alignText() -> some View {
        self.modifier(TaskAlignmentModifier())
    }
    
    func mark(isDone: Bool) -> some View {
        self
            .modifier(DoneModifier(isDone: isDone))
    }
}

enum SizeItem {
    case xsmall, small, medium, large, custom(CGFloat)
    
    var font: Font {
        switch self {
        case .xsmall: return Font.subheadline
        case .small: return Font.title3
        case .medium: return Font.title2
        case .large: return Font.title
        default: return Font.title2
        }
    }
    
    var scale: CGFloat {
        switch self {
        case .xsmall: return 15
        case .small: return 20
        case .medium: return 22
        case .large: return 28
        case .custom(let value): return value
        }
    }
}

struct SizeModifier: ViewModifier {
    
    let size: SizeItem

    func body(content: Content) -> some View {
        content
            .font(size.font)
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

struct CheckmarkAlignmentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .alignmentGuide(.firstTextBaseline) { context in
                context[VerticalAlignment.center]
            }
    }
}

struct TaskAlignmentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.alignmentGuide(.firstTextBaseline) { context in
            let remainingLine = (context.height - context[.lastTextBaseline])
            let lineHeight = context[.firstTextBaseline] + remainingLine
            let lineCenter = lineHeight / 2
            return lineCenter
        }
    }
}

struct DoneModifier: ViewModifier {
    let isDone: Bool
    
    func body(content: Content) -> some View {
        if isDone {
            return AnyView(content.strikethrough().greyed())
        } else {
            return AnyView(content.foregroundStyle(Color.text))
        }
    }
}
